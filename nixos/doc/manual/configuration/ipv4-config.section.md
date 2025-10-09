# IPv4 Configuration {#sec-ipv4}

By default, NixOS uses DHCP (specifically, `dhcpcd`) to automatically
configure network interfaces. However, you can configure an interface
manually as follows:

```nix
{
  networking.interfaces.eth0.ipv4.addresses = [
    {
      address = "192.168.1.2";
      prefixLength = 24;
    }
  ];
}
```

Typically you'll also want to set a default gateway and set of name
servers:

```nix
{
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "8.8.8.8" ];
}
```

::: {.note}
Statically configured interfaces are set up by the systemd service
`interface-name-cfg.service`. The default gateway and name server
configuration is performed by `network-setup.service`.
:::

The host name is set using [](#opt-networking.hostName):

```nix
{ networking.hostName = "cartman"; }
```

The default host name is `nixos`. Set it to the empty string (`""`) to
allow the DHCP server to provide the host name.
