# Netbird {#module-services-netbird}

## Quickstart {#module-services-netbird-quickstart}

The absolute minimal configuration for the netbird daemon looks like this:

```nix
services.netbird.enable = true;
```

This will set up a netbird service listening on the port `51820` associated to the
`wt0` interface.

It is strictly equivalent to setting:

```nix
services.netbird.tunnels.wt0.stateDir = "netbird";
```

The `enable` option is mainly kept for backward compatibility, as defining netbird
tunnels through the `tunnels` option is more expressive.

## Multiple connections setup {#module-services-netbird-multiple-connections}

Using the `services.netbird.tunnels` option, it is also possible to define more than
one netbird service running at the same time.

The following configuration will start a netbird daemon using the interface `wt1` and
the port 51830. Its configuration file will then be located at `/var/lib/netbird-wt1/config.json`.

```nix
services.netbird.tunnels = {
  wt1 = {
    port = 51830;
  };
};
```

To interact with it, you will need to specify the correct daemon address:

```bash
netbird --daemon-addr unix:///var/run/netbird-wt1/sock ...
```

The address will by default be `unix:///var/run/netbird-<name>`.

It is also possible to overwrite default options passed to the service, for
example:

```nix
services.netbird.tunnels.wt1.environment = {
  NB_DAEMON_ADDR = "unix:///var/run/toto.sock"
};
```

This will set the socket to interact with the netbird service to `/var/run/toto.sock`.
