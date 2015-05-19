###############################################################################################################
## This script was developed by Guberni and is part of Tellki monitoring solution                     		 ##
##                                                                                                      	 ##
## December, 2014                     	                                                                	 ##
##                                                                                                      	 ##
## Version 1.0                                                                                          	 ##
##																									    	 ##
## DESCRIPTION: Monitor system load average	(1min, 5min and 15min)											 ##
##																											 ##
## SYNTAX: ./load_Linux.sh <METRIC_STATE>             													     ##
##																											 ##
## EXAMPLE: ./load_Linux.sh "0,1,1"         														         ##
##																											 ##
##                                      ############                                                    	 ##
##                                      ## README ##                                                    	 ##
##                                      ############                                                    	 ##
##																											 ##
## This script is used combined with runremote.sh script, but you can use as standalone. 			    	 ##
##																											 ##
## runremote.sh - executes input script locally or at a remove server, depending on the LOCAL parameter.	 ##
##																											 ##
## SYNTAX: sh "runremote.sh" <HOST> <METRIC_STATE> <USER_NAME> <PASS_WORD> <TEMP_DIR> <SSH_KEY> <LOCAL> 	 ##
##																											 ##
## EXAMPLE: (LOCAL)  sh "runremote.sh" "load_Linux.sh" "192.168.1.1" "0,1,1" "" "" "" "" "1"                 ##
## 			(REMOTE) sh "runremote.sh" "load_Linux.sh" "192.168.1.1" "1,1,0" "user" "" "/tmp" "/key.ppk" "0" ##
##																											 ##
## HOST - hostname or ip address where script will be executed.                                         	 ##
## METRIC_STATE - is generated internally by Tellki and its only used by Tellki default monitors.       	 ##
##         		  1 - metric is on ; 0 - metric is off					              						 ##
## USER_NAME - user name required to connect to remote host. Empty ("") for local monitoring.           	 ##
## PASS_WORD - password required to connect to remote host. Empty ("") for local monitoring.            	 ##
## TEMP_DIR - (remote monitoring only): directory on remote host to copy scripts before being executed.		 ##
## SSH_KEY - private ssh key to connect to remote host. Empty ("null") if password is used.                  ##
## LOCAL - 1: local monitoring / 0: remote monitoring                                                   	 ##
###############################################################################################################


#METRIC_ID
ONEminAvg="77:Load 1min Avg:4"
FIVEminAvg="199:Load 5min Avg:4"
FIFTENminAvg="59:Load 15min Avg:4"


#INPUTS
ONEminAvg_on=`echo $1 | awk -F',' '{print $1}'`
FIVEminAvg_on=`echo $1 | awk -F',' '{print $2}'`
FIFTENminAvg_on=`echo $1 | awk -F',' '{print $3}'`

# Validate if all metrics were collected correctly
	if [ $ONEminAvg_on -eq 1 ]
	then
		ominavg=`uptime |awk -F':' '{print $NF}' | awk -F',' '{print $1}'| sed 's/ //g'`
		if [ "$ominavg" = "" ]
		then
			#Unable to collect metrics
			exit 8  
		fi
	fi
	if [ $FIVEminAvg_on -eq 1 ]
	then
		fivavg=`uptime |awk -F':' '{print $NF}' | awk -F',' '{print $2}'| sed 's/ //g'`
		if [ "$fivavg" = "" ]
		then
			#Unable to collect metrics
			exit 8 
		fi
	fi
	if [ $FIFTENminAvg_on -eq 1 ]
	then
		fif=`uptime |awk -F':' '{print $NF}' | awk -F',' '{print $3}'| sed 's/ //g'`
		if [ "$fif" = "" ]
		then
			#Unable to collect metrics
			exit 8 
		fi
	fi
	
# Send Metrics
if [ $ONEminAvg_on -eq 1 ]
then
	echo "$ONEminAvg|$ominavg|"
fi
if [ $FIVEminAvg_on -eq 1 ]
then
	echo "$FIVEminAvg|$fivavg|"
fi
if [ $FIFTENminAvg_on -eq 1 ]
then
	echo "$FIFTENminAvg|$fif|"
fi

