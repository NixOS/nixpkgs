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

## DNS Configuration {#module-services-netbird-dns}

NetBird provides DNS features for peer name resolution. You can customize or disable these:

```nix
{
  services.netbird.clients.work = {
    port = 51820;
    dns.disable = true; # Completely disable NetBird DNS
    dns.extraLabels = [ "myserver=10.0.0.5" ]; # Extra DNS labels
    dns.routeInterval = 5000; # DNS route update interval (ms)
  };
}
```

## Routing and Firewall Controls {#module-services-netbird-routing}

Fine-grained control over routing and firewall behavior:

```nix
{
  services.netbird.clients.restricted = {
    port = 51820;
    routing.disableClientRoutes = true; # Don't accept routes from peers
    routing.disableServerRoutes = true; # Don't advertise routes
    routing.blockLanAccess = true; # Block LAN access from NetBird
    routing.blockInbound = true; # Block all inbound connections
    firewall.disableNetbird = true; # Disable NetBird's built-in firewall
  };
}
```

## Security Features {#module-services-netbird-security}

### Rosenpass (Post-Quantum Cryptography) {#module-services-netbird-rosenpass}

Enable post-quantum key exchange for enhanced security:

```nix
{
  services.netbird.clients.secure = {
    port = 51820;
    rosenpass.enable = true;
    rosenpass.permissive = true; # Allow connections with non-Rosenpass peers
  };
}
```

See [the NetBird docs](https://docs.netbird.io/how-to/enable-post-quantum-cryptography) for more information.

### SSH Server {#module-services-netbird-ssh}

NetBird includes a built-in SSH server for remote access:

```nix
{
  services.netbird.clients.withSsh = {
    port = 51820;
    ssh.enable = true;
    ssh.permitRoot = false;
    ssh.sftp.enable = true;
    ssh.portForwarding.local = true;
    ssh.portForwarding.remote = false;
  };
}
```

## Connection Management {#module-services-netbird-connection}

Configure connection behavior:

```nix
{
  services.netbird.clients.lazy = {
    port = 51820;
    connection.lazy = true; # Connect only when traffic is detected
    connection.networkMonitor = true; # Enable network monitoring
    hostname = "my-custom-hostname"; # Custom peer hostname
  };
}
```

## Self-Hosted Deployments {#module-services-netbird-selfhosted}

For self-hosted NetBird deployments, configure custom server URLs:

```nix
{
  services.netbird.clients.selfhosted = {
    port = 51820;
    server.managementUrl = "https://management.example.com:443";
    server.adminUrl = "https://admin.example.com:443";
  };
}
```

## Advanced Configuration {#module-services-netbird-advanced}

Additional options for specific use cases:

```nix
{
  services.netbird.clients.advanced = {
    port = 51820;
    mtu = 1280; # Custom MTU
    externalIpMap = "192.168.1.100/32->203.0.113.50/32"; # NAT traversal
    interfaceBlacklist = [
      "docker0"
      "br-*"
    ]; # Exclude interfaces
    debug.anonymizeLogs = true; # Anonymize logs
    extraEnvironment = {
      # Additional env vars
      MY_CUSTOM_VAR = "value";
    };
  };
}
```
