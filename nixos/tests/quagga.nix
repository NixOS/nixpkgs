# This test runs Quagga and checks if OSPF routing works.
#
# Network topology:
#   [ client ]--net1--[ router1 ]--net2--[ router2 ]--net3--[ server ]
#
# All interfaces are in OSPF Area 0.

import ./make-test.nix ({ pkgs, ... }:
  let

    ifAddr = node: iface: (pkgs.lib.head node.config.networking.interfaces.${iface}.ip4).address;

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
          { config, pkgs, nodes, ... }:
          {
            virtualisation.vlans = [ 1 ];
            networking.defaultGateway = ifAddr nodes.router1 "eth1";
          };

        router1 =
          { config, pkgs, nodes, ... }:
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
          { config, pkgs, nodes, ... }:
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
          { config, pkgs, nodes, ... }:
          {
            virtualisation.vlans = [ 3 ];
            networking.defaultGateway = ifAddr nodes.router2 "eth1";
            networking.firewall.allowedTCPPorts = [ 80 ];
            networking.firewall.allowPing = true;
            services.httpd.enable = true;
            services.httpd.adminAddr = "foo@example.com";
          };
      };

      testScript =
        { nodes, ... }:
        ''
          startAll;

          # Wait for the networking to start on all machines
          $_->waitForUnit("network.target") foreach values %vms;

          # Wait for OSPF to form adjacencies
          for my $gw ($router1, $router2) {
              $gw->waitForUnit("ospfd");
              $gw->waitUntilSucceeds("vtysh -c 'show ip ospf neighbor' | grep Full");
              $gw->waitUntilSucceeds("vtysh -c 'show ip route' | grep '^O>'");
          }

          # Test ICMP.
          $client->succeed("ping -c 3 server >&2");

          # Test whether HTTP works.
          $server->waitForUnit("httpd");
          $client->succeed("curl --fail http://server/ >&2");
        '';
    })
