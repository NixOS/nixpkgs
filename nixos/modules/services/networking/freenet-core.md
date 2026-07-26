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

Nodes connect through existing gateways by default. To operate a publicly
reachable gateway instead, enable
{option}`services.freenet-core.gateway.enable` and set
{option}`services.freenet-core.gateway.publicAddress`. The advertised public
port defaults to the peer-to-peer listener port.

The web interface only listens on the loopback address by default. Set
{option}`services.freenet-core.websocketAddress` explicitly to expose it to
other hosts.

Freenet's built-in updater is disabled because the package is managed by Nix.
The service runs as a dynamic user. systemd manages its private state in
{file}`/var/lib/freenet-core` and logs in {file}`/var/log/freenet-core`.
