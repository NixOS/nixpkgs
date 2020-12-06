# This test runs Quagga and checks if OSPF routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#
# All interfaces are in OSPF Area 0.

import ./make-test-python.nix ({ pkgs, ... }:
  let

    ifAddr = node: iface: (pkgs.lib.head node.config.networking.interfaces.${iface}.ipv4.addresses).address;

    ospfConf = ''
      interface eth2
        ip ospf hello-interval 1
        ip ospf dead-interval 5
      !
      router ospf
        network 192.168.0.0/16 area 0
    '';

  in
    {
      name = "quagga";

      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = [ tavyc ];
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
            networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p ospf -j ACCEPT";
            services.quagga.ospf = {
              enable = true;
              config = ospfConf;
            };
          };

        router2 =
          { ... }:
          {
            virtualisation.vlans = [ 3 2 ];
            boot.kernel.sysctl."net.ipv4.ip_forward" = "1";
            networking.firewall.extraCommands = "iptables -A nixos-fw -i eth2 -p ospf -j ACCEPT";
            services.quagga.ospf = {
              enable = true;
              config = ospfConf;
            };
          };

        server =
          { nodes, ... }:
          {
            virtualisation.vlans = [ 3 ];
            networking.defaultGateway = ifAddr nodes.router2 "eth1";
            networking.firewall.allowedTCPPorts = [ 80 ];
            services.httpd.enable = true;
            services.httpd.adminAddr = "foo@example.com";
          };
      };

      testScript =
        { ... }:
        ''
          start_all()

          # Wait for the networking to start on all machines
          for machine in client, router1, router2, server:
              machine.wait_for_unit("network.target")

          with subtest("Wait for OSPF to form adjacencies"):
              for gw in router1, router2:
                  gw.wait_for_unit("ospfd")
                  gw.wait_until_succeeds("vtysh -c 'show ip ospf neighbor' | grep Full")
                  gw.wait_until_succeeds("vtysh -c 'show ip route' | grep '^O>'")

          with subtest("Test ICMP"):
              client.wait_until_succeeds("ping -c 3 server >&2")

          with subtest("Test whether HTTP works"):
              server.wait_for_unit("httpd")
              client.succeed("curl --fail http://server/ >&2")
        '';
    })
