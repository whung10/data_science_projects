/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT * 
FROM  `Facilities` 
WHERE membercost !=0

/*
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court
*/


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * ) 
FROM  `Facilities` 
WHERE membercost =0

/* 
Ans: 4 
*/


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM  `Facilities` 
WHERE membercost < monthlymaintenance * 0.2

/*
facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200
1	Tennis Court 2	5.0	200
2	Badminton Court	0.0	50
3	Table Tennis	0.0	10
4	Massage Room 1	9.9	3000
5	Massage Room 2	9.9	3000
6	Squash Court	3.5	80
7	Snooker Table	0.0	15
8	Pool Table	0.0	15
*/


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM  `Facilities` 
WHERE facid
IN ( 1, 5 ) 

/*
facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	
1	Tennis Court 2	5.0	25.0	8000	200
5	Massage Room 2	9.9	80.0	4000	3000
*/


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance >100
THEN  'expensive'
WHEN monthlymaintenance <=100
THEN  'cheap'
END AS note
FROM  `Facilities`

/*
name	monthlymaintenance	note	
Tennis Court 1	200	expensive
Tennis Court 2	200	expensive
Badminton Court	50	cheap
Table Tennis	10	cheap
Massage Room 1	3000	expensive
Massage Room 2	3000	expensive
Squash Court	80	cheap
Snooker Table	15	cheap
Pool Table	15	cheap
*/


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname, joindate
FROM  `Members` 
ORDER BY joindate DESC

/*
firstname	surname	joindate	
Darren	Smith	2012-09-26 18:08:45
Erica	Crumpet	2012-09-22 08:36:38
John	Hunt	2012-09-19 11:32:45
Hyacinth	Tupperware	2012-09-18 19:32:05
Millicent	Purview	2012-09-18 19:04:01
Henry	Worthington-Smyth	2012-09-17 12:27:15
...
*/


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT CONCAT(firstname, ' ', surname, '_', name) AS result
FROM Bookings
JOIN Facilities
JOIN Members ON Bookings.facid = Facilities.facid
AND Bookings.memid = Members.memid
WHERE Bookings.facid =0
OR Bookings.facid =1
ORDER BY Members.firstname, Members.surname

/*
result	
Anne Baker_Tennis Court 1
Anne Baker_Tennis Court 2
Burton Tracy_Tennis Court 1
Burton Tracy_Tennis Court 2
Charles Owen_Tennis Court 2
Charles Owen_Tennis Court 1
...
*/


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT CONCAT( Members.firstname,  ' ', Members.surname ) , Facilities.name, 
CASE WHEN Members.memid =0
THEN Facilities.guestcost * Bookings.slots
WHEN Members.memid !=0
THEN Facilities.membercost * Bookings.slots
END AS total_cost
FROM Bookings
JOIN Facilities
JOIN Members
WHERE Bookings.starttime LIKE  '2012-09-14%'
HAVING total_cost >30
ORDER BY total_cost DESC 

/*
CONCAT( Members.firstname, ' ', Members.surname )	name	total_cost	
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	320.0
...
*/

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT CONCAT( Members.firstname,  ' ', Members.surname ) , Facilities.name, 
CASE WHEN Members.memid =0
THEN Facilities.guestcost * Bookings.slots
WHEN Members.memid !=0
THEN Facilities.membercost * Bookings.slots
END AS total_cost
FROM Bookings
JOIN Facilities
JOIN Members
WHERE starttime IN (SELECT starttime FROM Bookings WHERE starttime LIKE '2012-09-14%')
HAVING total_cost >30
ORDER BY total_cost DESC 

/*
CONCAT( Members.firstname, ' ', Members.surname )	name	total_cost	
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 2	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 1	480.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 2	320.0
GUEST GUEST	Massage Room 1	320.0
...
*/


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT Facilities.name, 
CASE WHEN Bookings.memid =0 THEN SUM(Facilities.guestcost * Bookings.slots)
WHEN Bookings.memid !=0 THEN SUM(Facilities.membercost * Bookings.slots) END AS total_revenue
FROM Bookings JOIN Facilities
GROUP BY Facilities.facid
ORDER BY total_revenue DESC

/*
name	total_revenue	
Massage Room 1	90990.9
Massage Room 2	90990.9
Tennis Court 2	45955.0
Tennis Court 1	45955.0
Squash Court	32168.5
Snooker Table	0.0
Badminton Court	0.0
Pool Table	0.0
Table Tennis	0.0
*/

