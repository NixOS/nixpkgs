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
Addresses and routes for statically configured interfaces and the default
gateway are set up by systemd services named
`network-addresses-<interface>.service`. The name servers configuration,
instead, is performed by `network-local-commands.service` using resolvconf.
:::

::: {.note}
If needed, for example if addresses/routes were added/removed,
you can reset the network configuration by running
`systemctl restart networking-scripted.target`
:::

The host name is set using [](#opt-networking.hostName):

```nix
{ networking.hostName = "cartman"; }
```

The default host name is `nixos`. Set it to the empty string (`""`) to
allow the DHCP server to provide the host name.
