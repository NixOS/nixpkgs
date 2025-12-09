# Maintenance Mode {#sec-maintenance-mode}

You can enter rescue mode by running:

```ShellSession
# systemctl rescue
```

This will eventually give you a single-user root shell. Systemd will
stop (almost) all system services. To get out of maintenance mode, just
exit from the rescue shell.
