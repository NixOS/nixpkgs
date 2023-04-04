# Test environment for MACVLAN functionality.
#
# Just as it was the case for the existing `nixos-container` implementation, I originally
# planned an abstraction here as well, but decided against it for the following
# reasons:
# * systemd-networkd already provides well-designed abstractions for network configurations
#   and a certain degree of declarativity.
#
# * in case of networkd we'd have to (1) create a host-interface for a MACVLAN (of course)
#   and declare it as macvlan interface in the config of the *physical interface itself*.
#   This means that we'd need a way to declare this in NixOS which turns out to be non-trivial
#   since networkd only uses the first `.network` file (in lexical order) it can find
#   so there's a risk that we'd invalidate other configurations with this.
#
# So to summarize, the abstractions I tried were leaky and thus useless. But now that we can
# use systemd-nspawn itself for containers (and consider NixOS just a thin abstraction layer),
# this isn't a big deal IMHO.

import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "containers-next-macvlan";
  meta = with lib.maintainers; {
    maintainers = [ ma27 ];
  };

  nodes.client = { pkgs, ... }: {
    virtualisation.vlans = [ 2 ];
  };

  nodes.macvlan = { pkgs, lib, ... }: {
    networking.useNetworkd = true;
    virtualisation.vlans = [ 2 ];

    systemd.network.networks."40-eth1" = {
      matchConfig.Name = "eth1";
      networkConfig.DHCP = lib.mkForce "yes";
      networkConfig.MACVLAN = "mv-eth1-host";
      linkConfig.RequiredForOnline = "no";
      address = lib.mkForce [];
      addresses = lib.mkForce [];
    };

    # Even though it's tempting to name this `mv-eth1`, this will actually break
    # the ability to restart containers and may lead to very bad race conditions: nspawn
    # creates macvlan interfaces on the host and moves those into the container. Since
    # those are named `mv-<physif>` (`mv-eth1` in our case), an EEXIST will be returned
    # in `nspawn-network.c` (see `setup_macvlans`).
    systemd.network.networks."20-mv-eth1-host" = {
      matchConfig.Name = "mv-eth1-host";
      networkConfig.IPForward = "yes";
      dhcpV4Config.ClientIdentifier = "mac";
      address = lib.mkForce [
        "192.168.2.2/24"
      ];
    };
    systemd.network.netdevs."20-mv-eth1-host" = {
      netdevConfig = {
        Name = "mv-eth1-host";
        Kind = "macvlan";
      };
      extraConfig = ''
        [MACVLAN]
        Mode=bridge
      '';
    };

    systemd.nspawn.vlandemo.networkConfig.MACVLAN = "eth1";
    systemd.nspawn.ephvlan.networkConfig.MACVLAN = "eth1";

    nixos.containers = let
      mkNetworkCfg = index: {
        systemd.network = {
          networks."10-mv-eth1" = {
            matchConfig.Name = "mv-eth1";
            address = [ "192.168.2.${toString index}/24" ];
          };
          netdevs."10-mv-eth1" = {
            netdevConfig.Name = "mv-eth1";
            netdevConfig.Kind = "veth";
          };
        };
      };
    in {
      instances.vlandemo.system-config = mkNetworkCfg 5;
      instances.ephvlan = {
        ephemeral = true;
        system-config = mkNetworkCfg 9;
      };
    };
  };

  testScript = ''
    start_all()

    macvlan.wait_for_unit("multi-user.target")
    client.wait_for_unit("network-online.target")

    with subtest("MACVLANs"):
        macvlan.wait_until_succeeds("ping 192.168.2.2 -c3 >&2")
        macvlan.wait_until_succeeds("ping 192.168.2.5 -c3 >&2")
        client.wait_until_succeeds("ping 192.168.2.2 -c3 >&2")
        client.wait_until_succeeds("ping 192.168.2.5 -c3 >&2")

    with subtest("ephemeral w/ macvlan"):
        macvlan.succeed("ping -c3 192.168.2.9 -c3 >&2")
        macvlan.succeed("machinectl poweroff ephvlan")
        macvlan.wait_until_unit_stops("systemd-nspawn@ephvlan")
        macvlan.succeed("machinectl start ephvlan")
        macvlan.wait_until_succeeds("ping -c3 192.168.2.9 -c3 >&2")

    macvlan.succeed("machinectl poweroff vlandemo")
    macvlan.succeed("machinectl poweroff ephvlan")
  '';
})
