spawn micro file.txt
expect "file.txt"

send "Hello world!"
expect "Hello world!"

# ctrl-q (exit)
send "\021"

expect "Save changes to file.txt before closing?"
send "y"

expect eof
