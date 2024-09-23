# Declarative Container Specification {#sec-declarative-containers}

You can also specify containers and their configuration in the host's
`configuration.nix`. For example, the following specifies that there
shall be a container named `database` running PostgreSQL:

```nix
{
  containers.database =
    { config =
        { config, pkgs, ... }:
        { services.postgresql.enable = true;
        services.postgresql.package = pkgs.postgresql_14;
        };
    };
}
```

If you run `nixos-rebuild switch`, the container will be built. If the
container was already running, it will be updated in place, without
rebooting. The container can be configured to start automatically by
setting `containers.database.autoStart = true` in its configuration.

By default, declarative containers share the network namespace of the
host, meaning that they can listen on (privileged) ports. However, they
cannot change the network configuration. You can give a container its
own network as follows:

```nix
{
  containers.database = {
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
  };
}
```

This gives the container a private virtual Ethernet interface with IP
address `192.168.100.11`, which is hooked up to a virtual Ethernet
interface on the host with IP address `192.168.100.10`. (See the next
section for details on container networking.)

To disable the container, just remove it from `configuration.nix` and
run `nixos-rebuild
  switch`. Note that this will not delete the root directory of the
container in `/var/lib/nixos-containers`. Containers can be destroyed using
the imperative method: `nixos-container destroy foo`.

Declarative containers can be started and stopped using the
corresponding systemd service, e.g.
`systemctl start container@database`.
