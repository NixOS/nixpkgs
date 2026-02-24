# Netbird {#module-services-netbird}

## Quickstart {#module-services-netbird-quickstart}

The absolute minimal configuration for the Netbird client daemon looks like this:

```nix
{ services.netbird.enable = true; }
```

This will set up a netbird service listening on the port `51820` associated to the
`wt0` interface.

Which is equivalent to:

```nix
{
  services.netbird.clients.wt0 = {
    port = 51820;
    name = "netbird";
    interface = "wt0";
    hardened = false;
  };
}
```

This will set up a `netbird.service` listening on the port `51820` associated to the
`wt0` interface. There will also be `netbird-wt0` binary installed in addition to `netbird`.

see [clients](#opt-services.netbird.clients) option documentation for more details.

## Multiple connections setup {#module-services-netbird-multiple-connections}

Using the `services.netbird.clients` option, it is possible to define more than
one netbird service running at the same time.

You must at least define a `port` for the service to listen on, the rest is optional:

```nix
{
  services.netbird.clients.wt1.port = 51830;
  services.netbird.clients.wt2.port = 51831;
}
```

see [clients](#opt-services.netbird.clients) option documentation for more details.

## Exposing services internally on the Netbird network {#module-services-netbird-firewall}

You can easily expose services exclusively to Netbird network by combining
[`networking.firewall.interfaces`](#opt-networking.firewall.interfaces) rules
with [`interface`](#opt-services.netbird.clients._name_.interface) names:

```nix
{
  services.netbird.clients.priv.port = 51819;
  services.netbird.clients.work.port = 51818;
  networking.firewall.interfaces = {
    "${config.services.netbird.clients.priv.interface}" = {
      allowedUDPPorts = [ 1234 ];
    };
    "${config.services.netbird.clients.work.interface}" = {
      allowedTCPPorts = [ 8080 ];
    };
  };
}
```

### Additional customizations {#module-services-netbird-customization}

Each Netbird client service by default:

- runs in a [hardened](#opt-services.netbird.clients._name_.hardened) mode,
- starts with the system,
- [opens up a firewall](#opt-services.netbird.clients._name_.openFirewall) for direct (without TURN servers)
  peer-to-peer communication,
- can be additionally configured with environment variables,
- automatically determines whether `netbird-ui-<name>` should be available,
- does not enable [routing features](#opt-services.netbird.useRoutingFeatures) by default
  If you plan to use routing features, you must explicitly enable them. By enabling them, the service will
  configure the firewall and enable IP forwarding on the system.
  When set to `client` or `both`, reverse path filtering will be set to loose instead of strict.
  When set to `server` or `both`, IP forwarding will be enabled.

[autoStart](#opt-services.netbird.clients._name_.autoStart) allows you to start the client (an actual systemd service)
on demand, for example to connect to work-related or otherwise conflicting network only when required.
See the option description for more information.

## Client configuration {#module-services-netbird-client-configuration}

Following [RFC 0042](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md), the NetBird
client module provides two escape hatches for configuring upstream settings instead of individual typed
options:

- [`extraEnvironment`](#opt-services.netbird.clients._name_.extraEnvironment) — set `NB_*` environment
  variables that the NetBird client reads at startup. Values set here take precedence over the
  module's computed defaults.
- [`config`](#opt-services.netbird.clients._name_.config) — set keys in `config.json` (merged via
  `preStart`). This is useful for settings that are not exposed as environment variables.

See the
[NetBird environment variable reference](https://docs.netbird.io/how-to/cli/environment-variables)
for the full list of supported `NB_*` variables.

### DNS {#module-services-netbird-dns}

```nix
{
  services.netbird.clients.work = {
    port = 51820;
    extraEnvironment = {
      NB_DISABLE_DNS = "true";
      NB_EXTRA_DNS_LABELS = "myserver=10.0.0.5";
      NB_DNS_ROUTER_INTERVAL = "5000";
    };
  };
}
```

### Routing and firewall {#module-services-netbird-routing}

```nix
{
  services.netbird.clients.restricted = {
    port = 51820;
    extraEnvironment = {
      NB_DISABLE_CLIENT_ROUTES = "true";
      NB_DISABLE_SERVER_ROUTES = "true";
      NB_BLOCK_LAN_ACCESS = "true";
      NB_BLOCK_INBOUND = "true";
      NB_DISABLE_FIREWALL = "true";
    };
  };
}
```

### Rosenpass (post-quantum cryptography) {#module-services-netbird-rosenpass}

```nix
{
  services.netbird.clients.secure = {
    port = 51820;
    extraEnvironment = {
      NB_ENABLE_ROSENPASS = "true";
      NB_ROSENPASS_PERMISSIVE = "true"; # allow connections with non-Rosenpass peers
    };
  };
}
```

See [the NetBird docs](https://docs.netbird.io/how-to/enable-post-quantum-cryptography) for more information.

### SSH {#module-services-netbird-ssh}

```nix
{
  services.netbird.clients.withSsh = {
    port = 51820;
    extraEnvironment = {
      NB_ALLOW_SERVER_SSH = "true";
      NB_SSH_ALLOW_SFTP = "true";
      NB_SSH_ALLOW_LOCAL_PORT_FORWARDING = "true";
    };
  };
}
```

### Connection and hostname {#module-services-netbird-connection}

```nix
{
  services.netbird.clients.lazy = {
    port = 51820;
    extraEnvironment = {
      NB_ENABLE_LAZY_CONNECTION = "true";
      NB_DISABLE_NETWORK_MONITOR = "true";
      NB_HOSTNAME = "my-custom-hostname";
      NB_ANONYMIZE = "true";
    };
  };
}
```

### Self-hosted deployments (config.json) {#module-services-netbird-selfhosted}

For self-hosted NetBird deployments, use the `config` option to set `config.json` keys:

```nix
{
  services.netbird.clients.selfhosted = {
    port = 51820;
    config = {
      ManagementURL = "https://management.example.com:443";
      AdminURL = "https://admin.example.com:443";
      Mtu = 1280;
    };
  };
}
```

Consult [the source code](https://github.com/netbirdio/netbird/blob/88747e3e0191abc64f1e8c7ecc65e5e50a1527fd/client/internal/config.go#L49-L82)
or inspect an existing `config.json` for a complete list of available keys.
