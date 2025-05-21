# This test runs FRR and checks if OSPF routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#
# All interfaces are in OSPF Area 0.

import ./make-test-python.nix ({ pkgs, ... }:
  let

    ifAddr = node: iface: (pkgs.lib.head node.config.networking.interfaces.${iface}.ipv4.addresses).address;

    ospfConf1 = ''
      router ospf
        network 192.168.0.0/16 area 0
    '';

    ospfConf2 = ''
      interface eth2
        ip ospf hello-interval 1
        ip ospf dead-interval 5
      !
      router ospf
        network 192.168.0.0/16 area 0
    '';

  in
    {
      name = "frr";

      meta = with pkgs.lib.maintainers; {
        maintainers = [ ];
      };

      nodes = {

        client =
          { nodes, ... }:
          {
            virtualisation.vlans = [ 1 ];
            networking.defaultGateway = ifAddr nodes.router1 "eth1";
          };

        router1 =
          { ... }:
          {
            virtualisation.vlans = [ 1 2 ];
            boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
            networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p ospfigp -j ACCEPT";
            services.frr.ospf = {
              enable = true;
              config = ospfConf1;
            };

            specialisation.ospf.configuration = {
              services.frr.ospf.config = ospfConf2;
            };
          };

        router2 =
          { ... }:
          {
            virtualisation.vlans = [ 3 2 ];
            boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
            networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p ospfigp -j ACCEPT";
            services.frr.ospf = {
              enable = true;
              config = ospfConf2;
            };
          };

        server =
          { nodes, ... }:
          {
            virtualisation.vlans = [ 3 ];
            networking.defaultGateway = ifAddr nodes.router2 "eth1";
          };
      };

      testScript =
        { nodes, ... }:
        ''
          start_all()

          # Wait for the networking to start on all machines
          for machine in client, router1, router2, server:
              machine.wait_for_unit("network.target")

          with subtest("Wait for Zebra and OSPFD"):
              for gw in router1, router2:
                  gw.wait_for_unit("zebra")
                  gw.wait_for_unit("ospfd")

          router1.succeed("${nodes.router1.config.system.build.toplevel}/specialisation/ospf/bin/switch-to-configuration test >&2")

          with subtest("Wait for OSPF to form adjacencies"):
              for gw in router1, router2:
                  gw.wait_until_succeeds("vtysh -c 'show ip ospf neighbor' | grep Full")
                  gw.wait_until_succeeds("vtysh -c 'show ip route' | grep '^O>'")

          with subtest("Test ICMP"):
              client.wait_until_succeeds("ping -4 -c 3 server >&2")
        '';
    })
