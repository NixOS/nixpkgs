# Ad-Hoc Configuration {#ad-hoc-network-config}

You can use [](#opt-networking.localCommands) to
specify shell commands to be run at the end of `network-setup.service`. This
is useful for doing network configuration not covered by the existing NixOS
modules. For instance, to statically configure an IPv6 address:

```nix
{
  networking.localCommands = ''
    ip -6 addr add 2001:610:685:1::1/64 dev eth0
  '';
}
```
