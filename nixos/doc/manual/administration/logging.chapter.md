# Logging {#sec-logging}

System-wide logging is provided by systemd's *journal*, which subsumes
traditional logging daemons such as syslogd and klogd. Log entries are
kept in binary files in `/var/log/journal/`. The command `journalctl`
allows you to see the contents of the journal. For example,

```ShellSession
$ journalctl -b
```

shows all journal entries since the last reboot. (The output of
`journalctl` is piped into `less` by default.) You can use various
options and match operators to restrict output to messages of interest.
For instance, to get all messages from PostgreSQL:

```ShellSession
$ journalctl -u postgresql.service
-- Logs begin at Mon, 2013-01-07 13:28:01 CET, end at Tue, 2013-01-08 01:09:57 CET. --
...
Jan 07 15:44:14 hagbard postgres[2681]: [2-1] LOG:  database system is shut down
-- Reboot --
Jan 07 15:45:10 hagbard postgres[2532]: [1-1] LOG:  database system was shut down at 2013-01-07 15:44:14 CET
Jan 07 15:45:13 hagbard postgres[2500]: [1-1] LOG:  database system is ready to accept connections
```

Or to get all messages since the last reboot that have at least a
"critical" severity level:

```ShellSession
$ journalctl -b -p crit
Dec 17 21:08:06 mandark sudo[3673]: pam_unix(sudo:auth): auth could not identify password for [alice]
Dec 29 01:30:22 mandark kernel[6131]: [1053513.909444] CPU6: Core temperature above threshold, cpu clock throttled (total events = 1)
```

The system journal is readable by root and by users in the `wheel` and
`systemd-journal` groups. All users have a private journal that can be
read using `journalctl`.
