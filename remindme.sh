#!/usr/bin/env bash

# This script will speak and send a notification
# to the command center with whatever you want
# Time is in seconds

if [ $# -lt 2 ]
  then
    echo $0 time \<from now \(in seconds\)\> \<message \(use quotes with multiple words\)\>
    exit 1
fi

# Check that the first parameter is a number
numregex='^[0-9]+$'
if ! [[ $1 =~ $numregex ]] ; then
   echo "The first parameter should be a number" >&2; exit 1
fi

# To be user-friendly, let's get the timestamp of when the notification will
# be sent
now=`date +%s`
later=`expr $now + $1`

# Now we're going to build the command to execute via nohup
# The Mac-specific commands here are "say" and "osascript".
# For Linux it uses the "notify-send" command.
# For other *nixes, put whatever you want for notification.
if [ "$(uname)" == "Darwin" ]; then
  echo Okay, at `date -r $later` I\'ll remind you of: $2
  cmd="sleep $1; say $2; osascript -e 'display notification \"$2 \" with title \"remindme.sh\" subtitle \"`date -r $later` Reminder:\"'"
elif [ "$(uname)" == "Linux" ]; then
  echo Okay, at `date -d @$later` I\'ll remind you of: $2
  cmd="sleep $1; notify-send -u normal \"$2\""
fi

# Now we're gonna actually run the command. Because we're
# running as nohup, this script will end immediately and
# eventually the time will elapse and the notifications will
# be sent
nohup sh -c `eval $cmd` > /dev/null 2>&1 &
