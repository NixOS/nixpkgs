# Freenet {#module-services-freenet-core}

[Freenet](https://freenet.org/) is a peer-to-peer platform for decentralized
applications.

## Quick start {#module-services-freenet-core-quick-start}

```nix
{
  services.freenet-core = {
    enable = true;
    openFirewall = true;
  };
}
```

This starts a Freenet node, opens its peer-to-peer UDP port, and makes the web
interface available at <http://127.0.0.1:7509/>.

The web interface only listens on the loopback address by default. Set
{option}`services.freenet-core.websocketAddress` explicitly to expose it to
other hosts.

Freenet's built-in updater is disabled because the package is managed by Nix.
The module creates the configured data, configuration, and log directories with
permissions restricted to the service user.
