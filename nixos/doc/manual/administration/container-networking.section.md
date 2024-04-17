# Container Networking {#sec-container-networking}

When you create a container using `nixos-container create`, it gets it
own private IPv4 address in the range `10.233.0.0/16`. You can get the
container's IPv4 address as follows:

```ShellSession
# nixos-container show-ip foo
10.233.4.2

$ ping -c1 10.233.4.2
64 bytes from 10.233.4.2: icmp_seq=1 ttl=64 time=0.106 ms
```

Networking is implemented using a pair of virtual Ethernet devices. The
network interface in the container is called `eth0`, while the matching
interface in the host is called `ve-container-name` (e.g., `ve-foo`).
The container has its own network namespace and the `CAP_NET_ADMIN`
capability, so it can perform arbitrary network configuration such as
setting up firewall rules, without affecting or having access to the
host's network.

By default, containers cannot talk to the outside network. If you want
that, you should set up Network Address Translation (NAT) rules on the
host to rewrite container traffic to use your external IP address. This
can be accomplished using the following configuration on the host:

```nix
{
  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "eth0";
}
```

where `eth0` should be replaced with the desired external interface.
Note that `ve-+` is a wildcard that matches all container interfaces.

If you are using Network Manager, you need to explicitly prevent it from
managing container interfaces:

```nix
{
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
}
```

You may need to restart your system for the changes to take effect.
