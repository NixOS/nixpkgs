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

[environment](#opt-services.netbird.clients._name_.environment) allows you to pass additional configurations
through environment variables, but special care needs to be taken for overriding config location and
daemon address due [hardened](#opt-services.netbird.clients._name_.hardened) option.
