# Service Management {#sec-systemctl}

In NixOS, all system services are started and monitored using the
systemd program. systemd is the "init" process of the system (i.e. PID
1), the parent of all other processes. It manages a set of so-called
"units", which can be things like system services (programs), but also
mount points, swap files, devices, targets (groups of units) and more.
Units can have complex dependencies; for instance, one unit can require
that another unit must be successfully started before the first unit can
be started. When the system boots, it starts a unit named
`default.target`; the dependencies of this unit cause all system
services to be started, file systems to be mounted, swap files to be
activated, and so on.

## Interacting with a running systemd {#sect-nixos-systemd-general}

The command `systemctl` is the main way to interact with `systemd`. The
following paragraphs demonstrate ways to interact with any OS running
systemd as init system. NixOS is of no exception. The [next section
](#sect-nixos-systemd-nixos) explains NixOS specific things worth
knowing.

Without any arguments, `systemctl` the status of active units:

```ShellSession
$ systemctl
-.mount          loaded active mounted   /
swapfile.swap    loaded active active    /swapfile
sshd.service     loaded active running   SSH Daemon
graphical.target loaded active active    Graphical Interface
...
```

You can ask for detailed status information about a unit, for instance,
the PostgreSQL database service:

```ShellSession
$ systemctl status postgresql.service
postgresql.service - PostgreSQL Server
          Loaded: loaded (/nix/store/pn3q73mvh75gsrl8w7fdlfk3fq5qm5mw-unit/postgresql.service)
          Active: active (running) since Mon, 2013-01-07 15:55:57 CET; 9h ago
        Main PID: 2390 (postgres)
          CGroup: name=systemd:/system/postgresql.service
                  ├─2390 postgres
                  ├─2418 postgres: writer process
                  ├─2419 postgres: wal writer process
                  ├─2420 postgres: autovacuum launcher process
                  ├─2421 postgres: stats collector process
                  └─2498 postgres: zabbix zabbix [local] idle

Jan 07 15:55:55 hagbard postgres[2394]: [1-1] LOG:  database system was shut down at 2013-01-07 15:55:05 CET
Jan 07 15:55:57 hagbard postgres[2390]: [1-1] LOG:  database system is ready to accept connections
Jan 07 15:55:57 hagbard postgres[2420]: [1-1] LOG:  autovacuum launcher started
Jan 07 15:55:57 hagbard systemd[1]: Started PostgreSQL Server.
```

Note that this shows the status of the unit (active and running), all
the processes belonging to the service, as well as the most recent log
messages from the service.

Units can be stopped, started or restarted:

```ShellSession
# systemctl stop postgresql.service
# systemctl start postgresql.service
# systemctl restart postgresql.service
```

These operations are synchronous: they wait until the service has
finished starting or stopping (or has failed). Starting a unit will
cause the dependencies of that unit to be started as well (if
necessary).

## systemd in NixOS {#sect-nixos-systemd-nixos}

Packages in Nixpkgs sometimes provide systemd units with them, usually
in e.g `#pkg-out#/lib/systemd/`. Putting such a package in
`environment.systemPackages` doesn't make the service available to
users or the system.

In order to enable a systemd *system* service with provided upstream
package, use (e.g):

```nix
{
  systemd.packages = [ pkgs.packagekit ];
}
```

Usually NixOS modules written by the community do the above, plus take
care of other details. If a module was written for a service you are
interested in, you'd probably need only to use
`services.#name#.enable = true;`. These services are defined in
Nixpkgs' [ `nixos/modules/` directory
](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules). In case
the service is simple enough, the above method should work, and start
the service on boot.

*User* systemd services on the other hand, should be treated
differently. Given a package that has a systemd unit file at
`#pkg-out#/lib/systemd/user/`, using [](#opt-systemd.packages) will
make you able to start the service via `systemctl --user start`, but it
won't start automatically on login. However, You can imperatively
enable it by adding the package's attribute to
[](#opt-systemd.packages) and then do this (e.g):

```ShellSession
$ mkdir -p ~/.config/systemd/user/default.target.wants
$ ln -s /run/current-system/sw/lib/systemd/user/syncthing.service ~/.config/systemd/user/default.target.wants/
$ systemctl --user daemon-reload
$ systemctl --user enable syncthing.service
```

If you are interested in a timer file, use `timers.target.wants` instead
of `default.target.wants` in the 1st and 2nd command.

Using `systemctl --user enable syncthing.service` instead of the above,
will work, but it'll use the absolute path of `syncthing.service` for
the symlink, and this path is in `/nix/store/.../lib/systemd/user/`.
Hence [garbage collection](#sec-nix-gc) will remove that file and you
will wind up with a broken symlink in your systemd configuration, which
in turn will not make the service / timer start on login.

## Template units {#sect-nixos-systemd-template-units}

systemd supports templated units where a base unit can be started multiple
times with a different parameter. The syntax to accomplish this is
`service-name@instance-name.service`. Units get the instance name passed to
them (see `systemd.unit(5)`). NixOS has support for these kinds of units and
for template-specific overrides. A service needs to be defined twice, once
for the base unit and once for the instance. All instances must include
`overrideStrategy = "asDropin"` for the change detection to work. This
example illustrates this:
```nix
{
  systemd.services = {
    "base-unit@".serviceConfig = {
      ExecStart = "...";
      User = "...";
    };
    "base-unit@instance-a" = {
      overrideStrategy = "asDropin"; # needed for templates to work
      wantedBy = [ "multi-user.target" ]; # causes NixOS to manage the instance
    };
    "base-unit@instance-b" = {
      overrideStrategy = "asDropin"; # needed for templates to work
      wantedBy = [ "multi-user.target" ]; # causes NixOS to manage the instance
      serviceConfig.User = "root"; # also override something for this specific instance
    };
  };
}
```
