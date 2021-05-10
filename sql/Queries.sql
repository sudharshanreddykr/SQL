-- DDL QUERIES
-- list all databases
show databases;
-- create new database
create database EmployeeDB;
-- drop/delete database
drop database EmployeeDB;
-- select database
use employeedb;
-- create new table
create table testTbl(id int, name varchar(100), dob date);
-- drop table table_name
drop table testTbl;
-- alter table add_column
alter table testTbl 
add email varchar(200);
-- alter table drop_column
alter table testtbl
drop column age;
-- alter table changing_column_definition
alter table testtbl
modify column email varchar(300);

-- DML QUERIES : DATA
-- INSERT UPDATE DELETE
-- DATE : yyyy-mm-dd
insert into testtbl values
(100,'test','2000-12-01','test1@mail.com'),
(101,'test','2000-12-01','test2@mail.com'),
(102,'test','2000-12-01','test3@mail.com');
-- delete
delete from testtbl
-- update
-- update table_name set col_name=value, col_name=value
update testtbl set name='demo';
-- DQL : select
select * from testtbl;
select id,name from testtbl;
-- WHERE CLAUSE
select * from testtbl where id=100;
select * from testtbl where id!=100;
select * from testtbl where id<>100; -- not equal
select * from testtbl where id>100;
select * from testtbl where id<100;
select * from testtbl where id>=100;
select * from testtbl where id<=100;
-- IN / NOT IN : get selected values
select * from testtbl where email in ('test1@mail.com','test3@mail.com');
select * from testtbl where email not in ('test1@mail.com','test3@mail.com');
-- BETWEEN / NOT BETWEEN : number ranges
select * from testtbl where id between 100 and 101;
select * from testtbl where id not between 100 and 101;
-- LIKE / NOT LIKE : string/text
use classicmodels;
select * from customers where contactFirstName like 'ca%';
select * from customers where contactFirstName not like '_r%';
-- CONSTRAINTS
use employeedb;
-- NOT NULL : no null values are allowed in this column
create table notnulltest(id int not null, name varchar(200));
insert into notnulltest values(null,'test');
-- ALTER 
-- alter table table_name modify column_name data_type not null;
-- UNIQUE KEY : unique values in the table : one table can have multiple unique columns
-- can be null
create table uniquetest(
id int not null,
name varchar(200),
email varchar(200),
unique(email)
);
insert into uniquetest values
(1,'test','test@mail.com'),
(2,'demo','test@mail.com');
-- alter table table_name add unique (column_name)
-- PRIMARY KEY : unique values in column : only one P.K per table is allowed (relationships)
-- can not be null
create table pktest(
id int not null,
name varchar(200),
email varchar(200),
primary key(id)
);
insert into pktest values
(1,'test','test@mail.com'),
(1,'demo','test@mail.com');
-- alter table table_name add primary key (column_name)
-- FOREIGN KEY
create table customers(
id int,
name varchar(200),
primary key(id)
);
create table orders(
OrderId int,
OrderNumber int,
CustomerId int,
Primary key (OrderId),
Unique (OrderNumber),
Foreign key (CustomerId) references customers(id)
);
-- alter table table_name add foreign key (fk_col_name) references pk_table(pk_col_name)
insert into customers values(1,'test');
insert into orders values(1,1000,2);
-- CHECK : check the value being inserted
create table checktable(
id int,
name varchar(200),
age int,
check (age>18)
);
insert into checktable values(1,'test',12);
-- alter table table_name add check(col_name)
-- DEFAULT
create table usertbl(
	userid int,
    username varchar(200),
    useremail varchar(200) not null,
    usercity varchar(200) default 'bangalore',
    createdate datetime default NOW(),
     primary key(userid),unique(useremail)
);
insert into usertbl(userid,username,useremail) values(1,'test','test@mail.com');
select * from usertbl;
-- alter table table_name alter col_name set default default_value
-- unix timestamp, UTC

-- AUTO_INCREMENT
create table autotbltest(
	id int not null AUTO_INCREMENT,
    name varchar(200),
    age int,
    primary key(id)
);
insert into autotbltest(name,age) values('test',12);
select * from autotbltest;
-- alter table table_name auto_increment=100;

-- AND : multiple columns condition
SELECT * FROM classicmodels.customers 
where 
country='australia'
and
state='NSW';

-- OR : same column condition
SELECT * FROM classicmodels.customers 
where 
state='victoria'
or
state='NSW';
-- NOT : inverter : opposite manner
SELECT * FROM classicmodels.customers 
where 
country='australia'
and
Not state='NSW';
-- ORDER BY : asc | desc
SELECT * FROM classicmodels.customers 
order by country desc;

select * from classicmodels.customers
order by country, state;

select * from classicmodels.customers
order by country asc, state desc;

-- LIMIT : get first few records
SELECT * FROM classicmodels.orders limit 5;
SELECT * FROM classicmodels.orders order by ORDERNUMBER desc limit 5;

-- BUILT IN FUNCTIONS
SELECT min(amount) FROM classicmodels.payments;
select max(amount) from classicmodels.payments;
select count(amount) from classicmodels.payments;
select sum(amount) from classicmodels.payments;
select avg(amount) from classicmodels.payments;

-- ALIAS : short names
select sum(amount) as total_sales from classicmodels.payments;

-- JOINS
-- inner join : used to join common data from both tables
SELECT o.ordernumber,o.orderdate,o.status, c.customername, c.phone
FROM classicmodels.orders as o
inner join classicmodels.customers as c
on c.customernumber=o.customernumber;
-- left join : get all data from left table & matched records from right table
SELECT c.customername, c.phone, o.ordernumber
FROM classicmodels.customers as c
left join classicmodels.orders as o
on c.customernumber=o.customernumber
where o.ordernumber is null;
-- right join : get all data from left table & matched records from right table
SELECT c.customername, c.phone, o.ordernumber
FROM classicmodels.customers as c
right join classicmodels.orders as o
on c.customernumber=o.customernumber;
-- group by : cannot use a where clause instead use having
select count(customernumber) as customers_count, country
from classicmodels.customers
group by country
having count(customernumber)>10;
-- INDEX : indexing is used to increase the performance of ur select query
-- create index index_name on table_name(col_name)
-- P.K : indexed
create index checkno_index on classicmodels.payments(checknumber);
-- VIEWS : minimize the data to be displayed in a simplified manner 
create view classic_cars_view
as
SELECT * FROM classicmodels.products where productLine='classic cars';
select * from classic_cars_view;
-- STORED PROCEDURE
use classicmodels;
DELIMITER //
CREATE PROCEDURE GetClassicCars()
BEGIN
  SELECT * from products
  WHERE productline='classic cars';
END //
DELIMITER ;
call GetClassicCars();
-- STORED PROCEDURE WITH PARAMETERS
use classicmodels;
DELIMITER //
CREATE PROCEDURE GetProducts(IN product_type varchar(200))
BEGIN
  SELECT * from products
  WHERE productline=product_type;
END //
DELIMITER ;
call GetProducts('classic cars');
-- drop procedure GetProducts;
-- TRIGGERS
use employeedb;
CREATE TABLE Salaries (
    employeeNumber INT PRIMARY KEY,
    salary DECIMAL(10,2) NOT NULL DEFAULT 0
);
INSERT INTO Salaries(employeeNumber,salary)
VALUES
    (1002,5000),
    (1056,7000),
    (1076,8000);
CREATE TABLE SalaryBudgets(
    total DECIMAL(15,2) NOT NULL
);

INSERT INTO SalaryBudgets(total)
SELECT SUM(salary) 
FROM Salaries;

SELECT * FROM SalaryBudgets;

Delimiter //
CREATE TRIGGER after_salaries_delete
AFTER DELETE
ON Salaries FOR EACH ROW
begin
UPDATE SalaryBudgets 
SET total = total - old.salary;
end //
DELETE FROM Salaries
WHERE employeeNumber = 1002;