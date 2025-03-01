# Rebooting and Shutting Down {#sec-rebooting}

The system can be shut down (and automatically powered off) by doing:

```ShellSession
# shutdown
```

This is equivalent to running `systemctl poweroff`.

To reboot the system, run

```ShellSession
# reboot
```

which is equivalent to `systemctl reboot`. Alternatively, you can
quickly reboot the system using `kexec`, which bypasses the BIOS by
directly loading the new kernel into memory:

```ShellSession
# systemctl kexec
```

The machine can be suspended to RAM (if supported) using `systemctl suspend`,
and suspended to disk using `systemctl hibernate`.

These commands can be run by any user who is logged in locally, i.e. on
a virtual console or in X11; otherwise, the user is asked for
authentication.
