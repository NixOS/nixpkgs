# This test verifies that we can ping an IPv4-only server from an IPv6-only
# client via a NAT64 router using CLAT on the client. The hosts and networks
# are configured as follows:
#
#        +------
# Client | clat    Address: 192.0.0.1/32  (configured via clatd)
#        |         Route:   default
#        |
#        | eth1    Address: Assigned via SLAAC within 2001:db8::/64
#        |  |      Route:   default via IPv6LL address
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

{ lib, ... }:

{
  name = "clatd";

  meta.maintainers = with lib.maintainers; [
    hax404
    jmbaur
  ];

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
              Destination = "192.0.2.0/24";
              Gateway = "100.64.0.1";
            }
          ];
        };
      };
    };

    # The router is configured with static IPv4 addresses towards the server
    # and IPv6 addresses towards the client. DNS64 is exposed towards the
    # client so clatd is able to auto-discover the PLAT prefix. For NAT64, the
    # Well-Known prefix 64:ff9b::/96 is used. NAT64 is done with TAYGA which
    # provides the tun-interface nat64 and does the translation over it. The
    # IPv6 packets are sent to this interfaces and received as IPv4 packets and
    # vice versa. As TAYGA only translates IPv6 addresses to dedicated IPv4
    # addresses, it needs a pool of IPv4 addresses which must be at least as
    # big as the expected amount of clients. In this test, the packets from the
    # pool are directly routed towards the client. In normal cases, there would
    # be a second source NAT44 to map all clients behind one IPv4 address.
    router = {
      boot.kernel.sysctl = {
        "net.ipv4.conf.all.forwarding" = 1;
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

      systemd.network.networks."40-eth2" = {
        networkConfig.IPv6SendRA = true;
        ipv6Prefixes = [ { Prefix = "2001:db8::/64"; } ];
        ipv6PREF64Prefixes = [ { Prefix = "64:ff9b::/96"; } ];
        ipv6SendRAConfig = {
          EmitDNS = true;
          DNS = "_link_local";
        };
      };

      services.resolved.settings.Resolve.DNSStubListener = "no";

      networking.extraHosts = ''
        192.0.0.171 ipv4only.arpa
        192.0.0.170 ipv4only.arpa
      '';

      services.coredns = {
        enable = true;
        config = ''
          .:53 {
            bind ::
            hosts /etc/hosts
            dns64 64:ff9b::/96
          }
        '';
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
      };
    };

    # The client uses SLAAC to assign IPv6 addresses. To reach the IPv4-only
    # server, the client starts the clat daemon which starts and configures the
    # local IPv4 -> IPv6 translation via Tayga after discovering the PLAT
    # prefix via DNS64.
    client =
      { pkgs, ... }:
      {
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
            ipv6AcceptRAConfig.UsePREF64 = true;
          };
        };

        services.clatd.enable = true;

        environment.systemPackages = [ pkgs.mtr ];
      };
  };

  testScript = ''
    import json

    start_all()

    # wait for all machines to start up
    for machine in client, router, server:
      machine.wait_for_unit("network.target")

    with subtest("Wait for tayga and clatd"):
      router.wait_for_unit("tayga.service")
      client.wait_for_unit("clatd.service")
      # clatd checks if this system has IPv4 connectivity for 10 seconds
      client.wait_until_succeeds(
        'journalctl -u clatd -e | grep -q "Starting up TAYGA, using config file"'
      )

    with subtest("networkd exports PREF64 prefix"):
      assert json.loads(client.succeed("networkctl status eth1 --json=short"))[
          "NDisc"
      ]["PREF64"][0]["Prefix"] == [0x0, 0x64, 0xFF, 0x9B] + ([0] * 12)

    with subtest("Test ICMP"):
      client.wait_until_succeeds("ping -c3 100.64.0.2 >&2")

    with subtest("Test ICMP and show a traceroute"):
      client.wait_until_succeeds("mtr --show-ips --report-wide 100.64.0.2 >&2")

    client.log(client.execute("systemd-analyze security clatd.service")[1])
  '';
}
