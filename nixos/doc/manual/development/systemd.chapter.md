# Systemd  {#sec-systemd}

Systemd is a building block of most nixos modules.

From the [project's webpage](https://systemd.io/)
```
systemd is a suite of basic building blocks for a Linux system. It provides a system and service manager that runs as PID 1 and starts the rest of the system.

systemd provides aggressive parallelization capabilities, uses socket and D-Bus activation for starting services, offers on-demand starting of daemons, keeps track of processes using Linux control groups, maintains mount and automount points, and implements an elaborate transactional dependency-based service control logic. systemd supports SysV and LSB init scripts and works as a replacement for sysvinit.

Other parts include a logging daemon, utilities to control basic system configuration like the hostname, date, locale, maintain a list of logged-in users and running containers and virtual machines, system accounts, runtime directories and settings, and daemons to manage simple network configuration, network time synchronization, log forwarding, and name resolution.
```

This chapter aims at describing the most commonly used features of systemd in nixos.

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

```{=docbook}
<xi:include href="systemd-handling-dependencies.section.xml" />
<xi:include href="systemd-state-management.section.xml" />
<xi:include href="systemd-environment-and-secrets.section.xml" />
<xi:include href="systemd-additional-resources.section.xml" />
```
