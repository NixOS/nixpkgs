# Ad-Hoc Configuration {#ad-hoc-network-config}

You can use [](#opt-networking.localCommands) to specify shell commands to be
run after the network interfaces have been created, but not necessarily fully
configured.
This is useful for doing network configuration not covered by the existing
NixOS modules. For example, you can create a network namespace and a pair
of virtual ethernet devices like this:

```nix
{
  networking.localCommands = ''
    ip netns add mynet
    ip link add name veth-in type veth peer name veth-out
    ip link set dev veth-out netns mynet
  '';
}
```

::: {.note}
The commands should ideally be idempotent, so it's recommended to perform
cleanups of the state you create (e.g. virtual interfaces), or at least make
sure possible failures are handled.
:::
