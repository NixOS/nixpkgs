# Firewall {#sec-firewall}

NixOS has a simple stateful firewall that blocks incoming connections
and other unexpected packets. The firewall applies to both IPv4 and IPv6
traffic. It is enabled by default. It can be disabled as follows:

```nix
{ networking.firewall.enable = false; }
```

If the firewall is enabled, you can open specific TCP ports to the
outside world:

```nix
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
```

Note that TCP port 22 (ssh) is opened automatically if the SSH daemon is
enabled (`services.openssh.enable = true`). UDP ports can be opened through
[](#opt-networking.firewall.allowedUDPPorts).

To open ranges of TCP ports:

```nix
{
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 4000;
      to = 4007;
    }
    {
      from = 8000;
      to = 8010;
    }
  ];
}
```

Similarly, UDP port ranges can be opened through
[](#opt-networking.firewall.allowedUDPPortRanges).
