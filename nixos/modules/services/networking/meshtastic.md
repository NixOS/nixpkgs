# Meshtasticd {#module-services-meshtasticd}

[Meshtasticd](https://meshtastic.org/) daemon.

Meshtastic is an open-source, off-grid, decentralised mesh network designed to
run on affordable, low-power devices.

Meshtastic is a project that enables you to use inexpensive LoRa radios as a
long range off-grid communication platform in areas without existing or reliable
communications infrastructure. This project is 100% community driven and open
source!

## Quickstart {#module-services-meshtasticd-quickstart}

A minimal configuration:

```nix
{
  services.meshtasticd = {
    enable = true;
    port = 4403;
    settings = {
      Lora = {
        Module = "auto";
      };
      Webserver = {
        Port = 9443;
        RootPath = pkgs.meshtastic-web;
      };
      General = {
        MaxNodes = 200;
        MaxMessageQueue = 100;
        MACAddressSource = "eth0";
      };
    };
  };
}
```

By default Meshtasticd listens on all network interfaces. The example above
binds the daemon to port `4403` and the web UI to `9443`. This module
intentionally does not configure an reverse proxy for you, keeping the module
focused on the Meshtastic service itself. If you need to restrict access, use
firewall rules or put the web UI behind a reverse proxy (e.g.: Caddy, Nginx)
that binds to `127.0.0.1` and exposes only the proxy. This approach leaves proxy
choice and TLS configuration to the operator while documenting how to securely
expose the web UI when required.

## Configuration {#module-services-meshtasticd-config}

All available configuration directives are documented in the
[standard Meshtastic configuration file](https://github.com/meshtastic/firmware/blob/develop/bin/config-dist.yaml).

The service uses a dedicated user and group account (`meshtasticd`) by default.
If you override the service user, ensure it is a member of the `spi` and `gpio`
groups so it can access the required hardware devices, as mandated by
Meshtastic’s default `udev` rules.
