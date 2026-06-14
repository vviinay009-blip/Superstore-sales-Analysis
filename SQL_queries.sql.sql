/*	======================= 
	Data Validation
	======================= */

-- Total rows
SELECT COUNT(*) FROM superstore;

-- CHECK FOR NULLS
SELECT
	SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS null_quantity,
    SUM(CASE WHEN profit IS NULL THEN 1 ELSE 0 END) AS null_profits
FROM superstore;

-- DISTINCT COUNTS
SELECT
	COUNT(DISTINCT `order id`) AS total_orders,
    COUNT(DISTINCT `Customer id`) AS total_customers,
    COUNT(DISTINCT `product id`) AS total_products
FROM superstore;

/* 	======================
	BASIC BUSINESS KPIs
    ======================*/
    
-- TOTAL REVENUE AND PROFITS
SELECT 
	ROUND(SUM(`sales`),2) AS total_revenue,
    ROUND(SUM(`profit`),2) AS total_profit
FROM superstore;

-- AVERAGE ORDER VALUE
SELECT 
	ROUND(SUM(sales)/ COUNT(DISTINCT `order id`),2) AS avg_order_value
FROM superstore;

/*	====================
	SEGEMENT ANALYSIS
    ====================*/

-- REVENUE BY SEGMENT
SELECT segment, ROUND(SUM(sales),2) AS revenue
FROM superstore
GROUP BY segment;

-- PROFIT BY SEGMENT
SELECT segment, ROUND(SUM(profit),2) AS profit
FROM superstore
GROUP BY segment;

/*	===================== 
	REGIONAL ANALYSIS
    =====================*/

-- REVENUE BY REGION
SELECT `region`, ROUND(SUM(sales),2) AS revenue
FROM superstore
GROUP BY region;

-- PROFIT BY REGION
SELECT region, ROUND(SUM(profit),2) AS profit
FROM superstore
GROUP BY region;

/*	=========================
	STATE ANALYSIS
    =========================*/
-- TOP 5 STATES BY SALES
SELECT top_10, state, sales FROM
	(SELECT RANK() OVER (ORDER BY SUM(sales) DESC) AS top_10, state , ROUND(SUM(sales),2) AS sales
    FROM superstore
    GROUP BY state) AS t
limit 10;

-- BOTTOM 10 STATES BY PROFIT
SELECT bottom_10, state, `profit/loss` FROM
	(SELECT RANK() OVER (ORDER BY SUM(profit) ) AS bottom_10, state , ROUND(SUM(profit),2) AS `profit/loss`
    FROM superstore
    GROUP BY state) AS t
limit 10;

/*	========================
	CATEGORY ANALYSIS
    ========================*/
-- SALES BY CATEGORY
SELECT category, ROUND(SUM(sales),2) AS sales
FROM superstore
GROUP BY category;

-- PROFIT BY CATEGORY
SELECT category, ROUND(SUM(profit),2) AS profit
FROM superstore
GROUP BY category;

/*	=========================== 	
	SUB-CATEGORY ANALYSIS
	===========================*/

-- MOST PROFITABLE CATEGORIES
SELECT 
	`sub-category`, ROUND(SUM(profit),2) AS profit
FROM superstore
GROUP BY `sub-category`
HAVING profit > 0
ORDER BY profit DESC;

-- LEAST PROFITABLE CATEGORIES
SELECT 
	`sub-category`, ROUND(SUM(profit),2) AS `profit/loss`
FROM superstore
GROUP BY `sub-category`
ORDER BY `profit/loss` ;

/*	=========================
	PRODUCT ANALYSIS
    =========================*/

-- TOP 10 PRODUCTS BY REVENUE
SELECT `product id`, `product name`, revenue, top_10 FROM
		(SELECT `product ID`, `product name`, ROUND(SUM(sales),2) AS revenue,
		RANK() OVER (ORDER BY SUM(sales) DESC) AS top_10
FROM superstore
GROUP BY `product name`, `product ID`) AS t
HAVING top_10 <= 10;

-- TOP 10 PRODUCTS BY PROFIT
SELECT `product id`, `product name`, profit, top_10 FROM
		(SELECT `product ID`, `product name`, ROUND(SUM(profit),2) AS profit,
		RANK() OVER (ORDER BY SUM(profit) DESC) AS top_10
FROM superstore
GROUP BY `product name`, `product ID`) AS t
HAVING top_10 <= 10;

/*	========================
	CUSTOMER ANALYSIS
    ========================*/

-- TOP CUSTOMERS BY REVENUE
SELECT `customer id`, `customer name`, ROUND(SUM(sales), 2) AS revenue
FROM superstore
GROUP BY `customer id`, `customer name`
ORDER BY revenue DESC;

-- TOP CUSTOMERS BY PROFIT
SELECT `customer id`, `customer name`, ROUND(SUM(profit), 2) AS profit
FROM superstore
GROUP BY `customer id`, `customer name`
ORDER BY profit DESC;

/*	======================== 
	DISCOUNT ANALYSIS
	========================*/
    
    -- DOES DISCOUNT HURT PROFITABILITY?
    SELECT
		`discount`, ROUND(AVG(profit),2) AS avg_profit
	FROM superstore
	GROUP BY `discount`
    ORDER BY `discount`;
    
    -- PROFIT MARGIN BY CATEGORY
    SELECT
		category, ROUND(SUM(profit)/SUM(sales)*100,2) AS profit_margin
	FROM superstore
    GROUP BY category;
    
    -- RANKING POSTAL CODES BY SALES
    SELECT
		state, `postal code`, RANK() OVER (ORDER BY SUM(sales) DESC) as `rank`, ROUND(SUM(sales),2) AS revenue
	FROM superstore
    GROUP BY state,`postal code`;
    
    -- TOP 3 CUSTOMER IN EACH SEGEMNT
    SELECT segment, `customer id`, `customer name`, revenue, rnk
	FROM
		(SELECT segment, `customer id`, `customer name`, ROUND(SUM(sales),2) AS revenue,
        RANK() OVER(PARTITION BY segment ORDER BY ROUND(SUM(sales),2) DESC) AS rnk
	FROM superstore
    GROUP BY segment, `customer id`, `customer name`) AS s
    WHERE rnk <= 3;



--