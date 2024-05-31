# IPv6 Configuration {#sec-ipv6}

IPv6 is enabled by default. Stateless address autoconfiguration is used
to automatically assign IPv6 addresses to all interfaces, and Privacy
Extensions (RFC 4946) are enabled by default. You can adjust the default
for this by setting [](#opt-networking.tempAddresses). This option
may be overridden on a per-interface basis by
[](#opt-networking.interfaces._name_.tempAddress). You can disable
IPv6 support globally by setting:

```nix
{
  networking.enableIPv6 = false;
}
```

You can disable IPv6 on a single interface using a normal sysctl (in
this example, we use interface `eth0`):

```nix
{
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;
}
```

As with IPv4 networking interfaces are automatically configured via
DHCPv6. You can configure an interface manually:

```nix
{
  networking.interfaces.eth0.ipv6.addresses = [ {
    address = "fe00:aa:bb:cc::2";
    prefixLength = 64;
  } ];
}
```

For configuring a gateway, optionally with explicitly specified
interface:

```nix
{
  networking.defaultGateway6 = {
    address = "fe00::1";
    interface = "enp0s3";
  };
}
```

See [](#sec-ipv4) for similar examples and additional information.
