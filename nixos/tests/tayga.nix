# This test verifies that we can ping an IPv4-only server from an IPv6-only
# client via a NAT64 router. The hosts and networks are configured as follows:
#
#        +------
# Client | eth1    Address: 2001:db8::2/64
#        |  |      Route:   64:ff9b::/96 via 2001:db8::1
#        +--|---
#           | VLAN 3
#        +--|---
#        | eth2    Address: 2001:db8::1/64
# Router |
#        | nat64   Address: 64:ff9b::1/128
#        |         Route:   64:ff9b::/96
#        |         Address: 192.0.2.0/32
#        |         Route:   192.0.2.0/24
#        |
#        | eth1    Address: 100.64.0.1/24
#        +--|---
#           | VLAN 2
#        +--|---
# Server | eth1    Address: 100.64.0.2/24
#        |         Route:   192.0.2.0/24 via 100.64.0.1
#        +------

import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "tayga";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ hax404 ];
    };

    nodes = {
      # The server is configured with static IPv4 addresses. RFC 6052 Section 3.1
      # disallows the mapping of non-global IPv4 addresses like RFC 1918 into the
      # Well-Known Prefix 64:ff9b::/96. TAYGA also does not allow the mapping of
      # documentation space (RFC 5737). To circumvent this, 100.64.0.2/24 from
      # RFC 6589 (Carrier Grade NAT) is used here.
      # To reach the IPv4 address pool of the NAT64 gateway, there is a static
      # route configured. In normal cases, where the router would also source NAT
      # the pool addresses to one IPv4 addresses, this would not be needed.
      server = {
        virtualisation.vlans = [
          2 # towards router
        ];
        networking = {
          useDHCP = false;
          interfaces.eth1 = lib.mkForce { };
        };
        systemd.network = {
          enable = true;
          networks."vlan1" = {
            matchConfig.Name = "eth1";
            address = [
              "100.64.0.2/24"
            ];
            routes = [
              {
                routeConfig = {
                  Destination = "192.0.2.0/24";
                  Gateway = "100.64.0.1";
                };
              }
            ];
          };
        };
        programs.mtr.enable = true;
      };

      # The router is configured with static IPv4 addresses towards the server
      # and IPv6 addresses towards the client. For NAT64, the Well-Known prefix
      # 64:ff9b::/96 is used. NAT64 is done with TAYGA which provides the
      # tun-interface nat64 and does the translation over it. The IPv6 packets
      # are sent to this interfaces and received as IPv4 packets and vice versa.
      # As TAYGA only translates IPv6 addresses to dedicated IPv4 addresses, it
      # needs a pool of IPv4 addresses which must be at least as big as the
      # expected amount of clients. In this test, the packets from the pool are
      # directly routed towards the client. In normal cases, there would be a
      # second source NAT44 to map all clients behind one IPv4 address.
      router_systemd = {
        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };

        virtualisation.vlans = [
          2 # towards server
          3 # towards client
        ];

        networking = {
          useDHCP = false;
          useNetworkd = true;
          firewall.enable = false;
          interfaces.eth1 = lib.mkForce {
            ipv4 = {
              addresses = [
                {
                  address = "100.64.0.1";
                  prefixLength = 24;
                }
              ];
            };
          };
          interfaces.eth2 = lib.mkForce {
            ipv6 = {
              addresses = [
                {
                  address = "2001:db8::1";
                  prefixLength = 64;
                }
              ];
            };
          };
        };

        services.tayga = {
          enable = true;
          ipv4 = {
            address = "192.0.2.0";
            router = {
              address = "192.0.2.1";
            };
            pool = {
              address = "192.0.2.0";
              prefixLength = 24;
            };
          };
          ipv6 = {
            address = "2001:db8::1";
            router = {
              address = "64:ff9b::1";
            };
            pool = {
              address = "64:ff9b::";
              prefixLength = 96;
            };
          };
          mappings = {
            "192.0.2.42" = "2001:db8::2";
          };
        };
      };

      router_nixos = {
        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = 1;
        };

        virtualisation.vlans = [
          2 # towards server
          3 # towards client
        ];

        networking = {
          useDHCP = false;
          firewall.enable = false;
          interfaces.eth1 = lib.mkForce {
            ipv4 = {
              addresses = [
                {
                  address = "100.64.0.1";
                  prefixLength = 24;
                }
              ];
            };
          };
          interfaces.eth2 = lib.mkForce {
            ipv6 = {
              addresses = [
                {
                  address = "2001:db8::1";
                  prefixLength = 64;
                }
              ];
            };
          };
        };

        services.tayga = {
          enable = true;
          ipv4 = {
            address = "192.0.2.0";
            router = {
              address = "192.0.2.1";
            };
            pool = {
              address = "192.0.2.0";
              prefixLength = 24;
            };
          };
          ipv6 = {
            address = "2001:db8::1";
            router = {
              address = "64:ff9b::1";
            };
            pool = {
              address = "64:ff9b::";
              prefixLength = 96;
            };
          };
          mappings = {
            "192.0.2.42" = "2001:db8::2";
          };
        };
      };

      # The client is configured with static IPv6 addresses. It has also a static
      # route for the NAT64 IP space where the IPv4 addresses are mapped in. In
      # normal cases, there would be only a default route.
      client = {
        virtualisation.vlans = [
          3 # towards router
        ];

        networking = {
          useDHCP = false;
          interfaces.eth1 = lib.mkForce { };
        };

        systemd.network = {
          enable = true;
          networks."vlan1" = {
            matchConfig.Name = "eth1";
            address = [
              "2001:db8::2/64"
            ];
            routes = [
              {
                routeConfig = {
                  Destination = "64:ff9b::/96";
                  Gateway = "2001:db8::1";
                };
              }
            ];
          };
        };
        programs.mtr.enable = true;
      };
    };

    testScript = ''
      # start client and server
      for machine in client, server:
        machine.systemctl("start network-online.target")
        machine.wait_for_unit("network-online.target")
        machine.log(machine.execute("ip addr")[1])
        machine.log(machine.execute("ip route")[1])
        machine.log(machine.execute("ip -6 route")[1])

      # test systemd-networkd and nixos-scripts based router
      for router in router_systemd, router_nixos:
        router.start()
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")
        router.wait_for_unit("tayga.service")
        router.log(machine.execute("ip addr")[1])
        router.log(machine.execute("ip route")[1])
        router.log(machine.execute("ip -6 route")[1])

        with subtest("Wait for tayga"):
          router.wait_for_unit("tayga.service")

        with subtest("Test ICMP server -> client"):
          server.wait_until_succeeds("ping -c 3 192.0.2.42 >&2")

        with subtest("Test ICMP and show a traceroute server -> client"):
          server.wait_until_succeeds("mtr --show-ips --report-wide 192.0.2.42 >&2")

        with subtest("Test ICMP client -> server"):
          client.wait_until_succeeds("ping -c 3 64:ff9b::100.64.0.2 >&2")

        with subtest("Test ICMP and show a traceroute client -> server"):
          client.wait_until_succeeds("mtr --show-ips --report-wide 64:ff9b::100.64.0.2 >&2")

        router.log(router.execute("systemd-analyze security tayga.service")[1])
        router.shutdown()
    '';
  }
)
