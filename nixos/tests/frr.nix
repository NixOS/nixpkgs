# This test runs the FRR suite and multiple routing protocols in a
# chain. It has a client and a server that want to reach each other,
# which is only possible if all routing protocols converge.
#
# Network topology:
#   vlan1: client <-> router1 [192.168.1.0/24]
#   vlan2: router1 <-> router2 [10.1.0.1/32, 10.2.0.1/32]
#     here we first use OSPF for next-hop reachability
#     once established we use BGP on top to exchange routes
#   vlan3: router2 <-> server [192.168.3.0/24]
#

import ./make-test-python.nix ({ lib, pkgs, ... }:
    {
      name = "frr";

      meta.maintainers = with lib.maintainers;  [ hexa ];

      nodes = {

        client =
          { nodes, ... }:
          {
            virtualisation.vlans = [
              1 # router1
            ];

            networking = {
              useDHCP = false;
              firewall.enable = false;
              interfaces.eth1 = lib.mkForce {};
            };

            systemd.network.enable = true;
            systemd.network.networks."vlan1" = {
              matchConfig.Name = "eth1";
              address = [
                "192.168.1.100/24"
              ];
              gateway = [
                "192.168.1.1"
              ];
              linkConfig.RequiredForOnline = "routable";
            };
          };

        router1 =
          { ... }:
          {
            virtualisation.vlans = [
              1 # client
              2 # router2
            ];

            environment.systemPackages = with pkgs; [ tcpdump nftables iptables ];

            networking = {
              useDHCP = false;
              firewall.enable = false;
              interfaces.eth1 = lib.mkForce {};
              interfaces.eth2 = lib.mkForce {};
            };

            systemd.network.enable = true;
            systemd.network.networks."vlan1" = {
              matchConfig.Name = "eth1";
              address = [
                "192.168.1.1/24"
              ];
              networkConfig.IPForward = true;
              linkConfig.RequiredForOnline = "routable";
            };
            systemd.network.networks."vlan2" = {
              matchConfig.Name = "eth2";
              address = [
                "10.1.0.1/32"
              ];
              networkConfig.IPForward = true;
              linkConfig.RequiredForOnline = "routable";
            };

            # https://docs.frrouting.org/en/latest/ospfd.html#clicmd-ip-ospf-network-broadcast-non-broadcast-point-to-multipoint-point-to-point-dmvpn
            boot.kernel.sysctl."net.ipv4.conf.eth2.rp_filter" = 0;

            services.frr = {
              ospf = {
                enable = true;
                config = ''
                  router ospf
                    network 10.1.0.1/32 area 0

                  ospf router-id 10.1.0.1

                  interface eth2
                    ip ospf hello-interval 1
                    ip ospf dead-interval 5
                    ip ospf network point-to-point
                 '';
              };
              bgp = {
                enable = true;
                config = ''
                  router bgp 64600
                    bgp router-id 10.1.0.1
                    no bgp ebgp-requires-policy

                    address-family ipv4 unicast
                      network 192.168.1.0/24

                      neighbor eth2 interface remote-as internal
                '';
              };

            };
          };

        router2 =
          { nodes, ... }:
          {
            virtualisation.vlans = [
              2 # router1
              3 # server
            ];

            environment.systemPackages = with pkgs; [ tcpdump nftables iptables ];

            networking = {
              useDHCP = false;
              firewall.enable = false;
              interfaces.eth1 = lib.mkForce {};
              interfaces.eth2 = lib.mkForce {};
            };

            systemd.network.enable = true;
            systemd.network.networks."vlan2" = {
              matchConfig.Name = "eth1";
              address = [
                "10.2.0.1/32"
              ];
              networkConfig.IPForward = true;
              linkConfig.RequiredForOnline = "routable";
            };
            systemd.network.networks."vlan3" = {
              matchConfig.Name = "eth2";
              address = [
                "192.168.3.1/24"
              ];
              networkConfig.IPForward = true;
              linkConfig.RequiredForOnline = "routable";
            };

            # https://docs.frrouting.org/en/latest/ospfd.html#clicmd-ip-ospf-network-broadcast-non-broadcast-point-to-multipoint-point-to-point-dmvpn
            boot.kernel.sysctl."net.ipv4.conf.eth1.rp_filter" = 0;

            services.frr = {
              ospf = {
                enable = true;
                config = ''
                  router ospf
                    network 10.2.0.1/32 area 0

                  ospf router-id 10.2.0.1

                  interface eth1
                    ip ospf hello-interval 1
                    ip ospf dead-interval 5
                    ip ospf network point-to-point
                '';
              };
              bgp = {
                enable = true;
                config = ''
                  router bgp 64601
                    bgp router-id 10.2.0.1
                    no bgp ebgp-requires-policy

                    address-family ipv4 unicast
                      network 192.168.3.0/24

                      neighbor eth1 interface remote-as internal
                  !
                '';
              };
            };
          };

        server =
          { nodes, ... }:
          {
            virtualisation.vlans = [
              3 # router2
            ];

            networking = {
              useDHCP = false;
              firewall.enable = false;
              interfaces.eth1 = lib.mkForce {};
            };

            systemd.network.enable = true;
            systemd.network.networks."vlan3" = {
              matchConfig.Name = "eth1";
              address = [
                "192.168.3.100/24"
              ];
              gateway = [
                "192.168.3.1"
              ];
              linkConfig.RequiredForOnline = "routable";
            };
          };

      };

      testScript =
        { nodes, ... }:
        ''
          start_all()

          # Wait for the networking to start on all machines
          for machine in client, router1, router2, server:
              machine.wait_for_unit("network-online.target")
              machine.log(machine.execute("ip addr")[1])

          with subtest("Wait for Zebra"):
              for machine in router1, router2:
                  machine.wait_for_unit("zebra")

          with subtest("Wait for OSPFD"):
              for machine in router1, router2:
                  machine.wait_for_unit("ospfd")

          with subtest("Wait for OSPF to form adjacencies"):
              for machine in router1, router2:
                  machine.wait_until_succeeds("vtysh -c 'show ip ospf neighbor' | grep Full")
                  machine.log(machine.execute("vtysh -c 'show ip ospf neighbor'")[1])

              router1.wait_until_succeeds("ping -c 3 router2 >2&")
              router2.wait_until_succeeds("ping -c 3 router1 >2&")

          with subtest("Wait for BGPD"):
              for machine in router1, router2:
                  machine.wait_for_unit("bgpd")

          with subtest("Wait for BGP sessions"):
              router1.log(router1.execute("vtysh -c 'show ip bgp summary'")[1])
              router1.log(router1.execute("vtysh -c 'show ip bgp neighbor'")[1])
              router1.log(router1.execute("vtysh -c 'show ip route'")[1])

          router1.log(router1.execute("vtysh -c 'show bgp summary'")[1])

          with subtest("Test ICMP"):
              client.wait_until_succeeds("ping -c 3 server >&2")
        '';
    })
