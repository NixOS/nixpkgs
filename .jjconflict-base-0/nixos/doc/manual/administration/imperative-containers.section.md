# Imperative Container Management {#sec-imperative-containers}

We'll cover imperative container management using `nixos-container`
first. Be aware that container management is currently only possible as
`root`, and that you need to enable [](#opt-boot.enableContainers) explicitly.

You create a container with identifier `foo` as follows:

```ShellSession
# nixos-container create foo
```

This creates the container's root directory in `/var/lib/nixos-containers/foo`
and a small configuration file in `/etc/nixos-containers/foo.conf`. It also
builds the container's initial system configuration and stores it in
`/nix/var/nix/profiles/per-container/foo/system`. You can modify the
initial configuration of the container on the command line. For
instance, to create a container that has `sshd` running, with the given
public key for `root`:

```ShellSession
# nixos-container create foo --config '
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = ["ssh-dss AAAAB3N…"];
'
```

By default the next free address in the `10.233.0.0/16` subnet will be
chosen as container IP. This behavior can be altered by setting
`--host-address` and `--local-address`:

```ShellSession
# nixos-container create test --config-file test-container.nix \
    --local-address 10.235.1.2 --host-address 10.235.1.1
```

Creating a container does not start it. To start the container, run:

```ShellSession
# nixos-container start foo
```

This command will return as soon as the container has booted and has
reached `multi-user.target`. On the host, the container runs within a
systemd unit called `container@container-name.service`. Thus, if
something went wrong, you can get status info using `systemctl`:

```ShellSession
# systemctl status container@foo
```

If the container has started successfully, you can log in as root using
the `root-login` operation:

```ShellSession
# nixos-container root-login foo
[root@foo:~]#
```

Note that only root on the host can do this (since there is no
authentication). You can also get a regular login prompt using the
`login` operation, which is available to all users on the host:

```ShellSession
# nixos-container login foo
foo login: alice
Password: ***
```

With `nixos-container run`, you can execute arbitrary commands in the
container:

```ShellSession
# nixos-container run foo -- uname -a
Linux foo 3.4.82 #1-NixOS SMP Thu Mar 20 14:44:05 UTC 2014 x86_64 GNU/Linux
```

There are several ways to change the configuration of the container.
First, on the host, you can edit
`/var/lib/nixos-containers/foo/etc/nixos/configuration.nix`, and run

```ShellSession
# nixos-container update foo
```

This will build and activate the new configuration. You can also specify
a new configuration on the command line:

```ShellSession
# nixos-container update foo --config '
  services.httpd.enable = true;
  services.httpd.adminAddr = "foo@example.org";
  networking.firewall.allowedTCPPorts = [ 80 ];
'

# curl http://$(nixos-container show-ip foo)/
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">…
```

However, note that this will overwrite the container's
`/etc/nixos/configuration.nix`.

Alternatively, you can change the configuration from within the
container itself by running `nixos-rebuild switch` inside the container.
Note that the container by default does not have a copy of the NixOS
channel, so you should run `nix-channel --update` first.

Containers can be stopped and started using `nixos-container
  stop` and `nixos-container start`, respectively, or by using
`systemctl` on the container's service unit. To destroy a container,
including its file system, do

```ShellSession
# nixos-container destroy foo
```
