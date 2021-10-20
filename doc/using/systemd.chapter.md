# Systemd  {#chap-systemd}

From the [project's webpage](https://systemd.io/)
```
systemd is a suite of basic building blocks for a Linux system. It provides a system and service manager that runs as PID 1 and starts the rest of the system.

systemd provides aggressive parallelization capabilities, uses socket and D-Bus activation for starting services, offers on-demand starting of daemons, keeps track of processes using Linux control groups, maintains mount and automount points, and implements an elaborate transactional dependency-based service control logic. systemd supports SysV and LSB init scripts and works as a replacement for sysvinit.

Other parts include a logging daemon, utilities to control basic system configuration like the hostname, date, locale, maintain a list of logged-in users and running containers and virtual machines, system accounts, runtime directories and settings, and daemons to manage simple network configuration, network time synchronization, log forwarding, and name resolution.
```

Index

- usage in modules
  - Starting a service
    [ref](https://man.archlinux.org/man/systemd.service.5.en)
  - Handling dependencies
    Talk about `requires` `wants` `after` `partOf` and the likes
    [ref](https://man.archlinux.org/man/systemd.unit.5#%5BUNIT%5D_SECTION_OPTIONS)
  - Environment
    Talk about `environment` how to use it and not passing secrets
    [ref](https://man.archlinux.org/man/systemd.exec.5.en#ENVIRONMENT)
  - Managing state
    Talk about StateDir RunDir WorkingDir and when to use each
  - Initialisation of state and dependents (e.g. database)
    Talk about adding a systemd service to handle database initialisation
  - Database management
    Talk about connection via a unix socket for more performance and reduced secret management
  - Managing secrets
    Talk about LoadCredential and how to use it
    [ref](https://man.archlinux.org/man/systemd.exec.5.en#CREDENTIALS)
  - Security and principle of least privilege
    Talk about `DynamicUser` and user management
    [ref](https://man.archlinux.org/man/systemd.exec.5.en#USER/GROUP_IDENTITY)
  - Template units
    Show an example and explain why you would use them
  - Advanced topics
    - Capabilities
    [ref](https://man.archlinux.org/man/systemd.exec.5.en#CAPABILITIES)
    - Socket activation for zero downtime deploys

- cli usage
- Additional resources

## cli usage {#sec-systemd-cli-usage}

This section aims to list most commonly used systemd commands when using NixOS. See the [Additonal resources section](#sec-systemd-additional-resources) for more information.

- list all running services `systemctl`
- list install unit files `systemctl list-unit-files`
- see the status of a service `systemctl status example.service`

[systemctl man page](https://man.archlinux.org/man/systemctl.1.en)

Journalctl is the main program to view logs for services

- view logs of failed services `journalctl -xeu`
- view logs of a particular failed service `journalctl -xeu example.service`

[journalctl man page](https://man.archlinux.org/man/journalctl.1.en)

## Additional resources {#sec-systemd-additional-resources}

[Systemd official website](https://systemd.io/)
[Wikipedia](https://en.wikipedia.org/wiki/Systemd)
[Debian](https://wiki.debian.org/systemd)
[Systemd announcement from Lennart Poettering (one of the 2 original developpers of systemd)](http://0pointer.de/blog/projects/systemd.html)
