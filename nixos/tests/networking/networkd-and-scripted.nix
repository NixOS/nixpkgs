{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
  # bool: whether to use networkd in the tests
  networkd,
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;
  router = import ./router.nix { inherit networkd; };
  clientConfig =
    extraConfig:
    lib.recursiveUpdate {
      networking.useDHCP = false;
      networking.useNetworkd = networkd;
    } extraConfig;
  testCases = {
    loopback = {
      name = "Loopback";
      nodes.client = clientConfig { };
      testScript = ''
        start_all()
        client.wait_for_unit("network.target")
        loopback_addresses = client.succeed("ip addr show lo")
        assert "inet 127.0.0.1/8" in loopback_addresses
        assert "inet6 ::1/128" in loopback_addresses
      '';
    };
    static = {
      name = "Static";
      nodes.router = router;
      nodes.client = clientConfig {
        virtualisation.interfaces.enp1s0.vlan = 1;
        virtualisation.interfaces.enp2s0.vlan = 2;
        networking = {
          defaultGateway = {
            address = "192.168.1.1";
            interface = "enp1s0";
          };
          defaultGateway6 = {
            address = "fd00:1234:5678:1::1";
            interface = "enp1s0";
          };
          interfaces.enp1s0.ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
            {
              address = "192.168.1.3";
              prefixLength = 32;
            }
            {
              address = "192.168.1.10";
              prefixLength = 32;
            }
          ];
          interfaces.enp2s0.ipv4.addresses = [
            {
              address = "192.168.2.2";
              prefixLength = 24;
            }
          ];
        };
      };
      testScript = ''
        start_all()

        client.wait_for_unit("network.target")
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")

        with subtest("Make sure DHCP server is not started"):
            client.fail("systemctl status kea-dhcp4-server.service")
            client.fail("systemctl status kea-dhcp6-server.service")

        with subtest("Test vlan 1"):
            client.wait_until_succeeds("ping -c 1 192.168.1.1")
            router.wait_until_succeeds("ping -c 1 192.168.1.2")
            router.wait_until_succeeds("ping -c 1 192.168.1.3")
            router.wait_until_succeeds("ping -c 1 192.168.1.10")

        with subtest("Test vlan 2"):
            client.wait_until_succeeds("ping -c 1 192.168.2.1")
            router.wait_until_succeeds("ping -c 1 192.168.2.2")

        with subtest("Test default gateway"):
            client.wait_until_succeeds("ping -c 1 192.168.3.1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:3::1")
      '';
    };
    routeType = {
      name = "RouteType";
      nodes.client = clientConfig {
        networking = {
          interfaces.eth1.ipv4.routes = [
            {
              address = "192.168.1.127";
              prefixLength = 32;
              type = "local";
            }
          ];
        };
      };
      testScript = ''
        start_all()
        client.wait_for_unit("network.target")
        client.succeed("ip -4 route list table local | grep 'local 192.168.1.127'")
      '';
    };
    dhcpDefault = {
      name = "useDHCP-by-default";
      nodes.router = router;
      nodes.client = {
        # Disable test driver default config
        networking.interfaces = lib.mkForce {
          # Make sure DHCP defaults correctly even when some unrelated config
          # is set on the interface (nothing, in this case).
          enp1s0 = { };
        };
        networking.useNetworkd = networkd;
        virtualisation.interfaces.enp1s0.vlan = 1;
      };
      testScript = ''
        start_all()
        client.wait_for_unit("multi-user.target")
        client.wait_until_succeeds("ip addr show dev enp1s0 | grep '192.168.1'")
        router.succeed("ping -c 1 192.168.1.1")
        client.succeed("ping -c 1 192.168.1.2")
      '';
    };
    dhcpSimple = {
      name = "SimpleDHCP";
      nodes.router = router;
      nodes.client = clientConfig {
        virtualisation.interfaces.enp1s0.vlan = 1;
        virtualisation.interfaces.enp2s0.vlan = 2;
        networking = {
          interfaces.enp1s0.useDHCP = true;
          interfaces.enp2s0.useDHCP = true;
        };
      };
      testScript = ''
        router.start()
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")

        client.start()
        client.wait_for_unit("network.target")

        with subtest("Wait until we have an ip address on each interface"):
            client.wait_until_succeeds("ip addr show dev enp1s0 | grep -q '192.168.1'")
            client.wait_until_succeeds("ip addr show dev enp1s0 | grep -q 'fd00:1234:5678:1:'")
            client.wait_until_succeeds("ip addr show dev enp2s0 | grep -q '192.168.2'")
            client.wait_until_succeeds("ip addr show dev enp2s0 | grep -q 'fd00:1234:5678:2:'")

        with subtest("Wait until we have received the nameservers"):
          if "${builtins.toJSON networkd}" == "true":
            client.wait_until_succeeds("resolvectl status enp2s0 | grep -q 2001:db8::1")
            client.wait_until_succeeds("resolvectl status enp2s0 | grep -q 192.168.2.1")
          else:
            client.wait_until_succeeds("resolvconf -l | grep -q 2001:db8::1")
            client.wait_until_succeeds("resolvconf -l | grep -q 192.168.2.1")

        with subtest("Test vlan 1"):
            client.wait_until_succeeds("ping -c 1 192.168.1.1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")
            router.wait_until_succeeds("ping -c 1 192.168.1.2")
            router.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::2")

        with subtest("Test vlan 2"):
            client.wait_until_succeeds("ping -c 1 192.168.2.1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::1")
            router.wait_until_succeeds("ping -c 1 192.168.2.2")
            router.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::2")
      '';
    };
    dhcpOneIf = {
      name = "OneInterfaceDHCP";
      nodes.router = router;
      nodes.client = clientConfig {
        virtualisation.interfaces.enp1s0.vlan = 1;
        virtualisation.interfaces.enp2s0.vlan = 2;
        networking = {
          interfaces.enp1s0 = {
            mtu = 1343;
            useDHCP = true;
          };
        };
      };
      testScript = ''
        start_all()

        with subtest("Wait for networking to come up"):
            client.wait_for_unit("network.target")
            router.wait_for_unit("network.target")

        with subtest("Wait until we have an ip address on each interface"):
            client.wait_until_succeeds("ip addr show dev enp1s0 | grep -q '192.168.1'")

        with subtest("ensure MTU is set"):
            assert "mtu 1343" in client.succeed("ip link show dev enp1s0")

        with subtest("Test vlan 1"):
            client.wait_until_succeeds("ping -c 1 192.168.1.1")
            router.wait_until_succeeds("ping -c 1 192.168.1.2")

        with subtest("Test vlan 2"):
            client.wait_until_succeeds("ping -c 1 192.168.2.1")
            client.fail("ping -c 1 192.168.2.2")

            router.wait_until_succeeds("ping -c 1 192.168.2.1")
            router.fail("ping -c 1 192.168.2.2")
      '';
    };
    bond =
      let
        node =
          address:
          clientConfig {
            virtualisation.interfaces.enp1s0.vlan = 1;
            virtualisation.interfaces.enp2s0.vlan = 2;
            networking = {
              bonds.bond0 = {
                interfaces = [
                  "enp1s0"
                  "enp2s0"
                ];
                driverOptions.mode = "802.3ad";
              };
              interfaces.bond0.ipv4.addresses = lib.mkOverride 0 [
                {
                  inherit address;
                  prefixLength = 30;
                }
              ];
            };
          };
      in
      {
        name = "Bond";
        nodes.client1 = node "192.168.1.1";
        nodes.client2 = node "192.168.1.2";
        testScript = ''
          start_all()

          with subtest("Wait for networking to come up"):
              client1.wait_for_unit("network.target")
              client2.wait_for_unit("network.target")

          with subtest("Test bonding"):
              client1.wait_until_succeeds("ping -c 2 192.168.1.1")
              client1.wait_until_succeeds("ping -c 2 192.168.1.2")

              client2.wait_until_succeeds("ping -c 2 192.168.1.1")
              client2.wait_until_succeeds("ping -c 2 192.168.1.2")

          with subtest("Verify bonding mode"):
              for client in client1, client2:
                  client.succeed('grep -q "Bonding Mode: IEEE 802.3ad Dynamic link aggregation" /proc/net/bonding/bond0')
        '';
      };
    bridge =
      let
        node =
          { address, vlan }:
          { pkgs, ... }:
          {
            virtualisation.interfaces.enp1s0.vlan = vlan;
            networking = {
              useNetworkd = networkd;
              useDHCP = false;
              interfaces.enp1s0.ipv4.addresses = [
                {
                  inherit address;
                  prefixLength = 24;
                }
              ];
            };
          };
      in
      {
        name = "Bridge";
        nodes.client1 = node {
          address = "192.168.1.2";
          vlan = 1;
        };
        nodes.client2 = node {
          address = "192.168.1.3";
          vlan = 2;
        };
        nodes.router = {
          virtualisation.interfaces.enp1s0.vlan = 1;
          virtualisation.interfaces.enp2s0.vlan = 2;
          networking = {
            useNetworkd = networkd;
            useDHCP = false;
            bridges.bridge.interfaces = [
              "enp1s0"
              "enp2s0"
            ];
            interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [ ];
            interfaces.eth2.ipv4.addresses = lib.mkOverride 0 [ ];
            interfaces.bridge.ipv4.addresses = lib.mkOverride 0 [
              {
                address = "192.168.1.1";
                prefixLength = 24;
              }
            ];
          };
        };
        testScript = ''
          start_all()

          with subtest("Wait for networking to come up"):
              for machine in client1, client2, router:
                  machine.wait_for_unit("network.target")

          with subtest("Test bridging"):
              client1.wait_until_succeeds("ping -c 1 192.168.1.1")
              client1.wait_until_succeeds("ping -c 1 192.168.1.2")
              client1.wait_until_succeeds("ping -c 1 192.168.1.3")

              client2.wait_until_succeeds("ping -c 1 192.168.1.1")
              client2.wait_until_succeeds("ping -c 1 192.168.1.2")
              client2.wait_until_succeeds("ping -c 1 192.168.1.3")

              router.wait_until_succeeds("ping -c 1 192.168.1.1")
              router.wait_until_succeeds("ping -c 1 192.168.1.2")
              router.wait_until_succeeds("ping -c 1 192.168.1.3")
        '';
      };
    macvlan = {
      name = "MACVLAN";
      nodes.router = router;
      nodes.client =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.iptables ]; # to debug firewall rules
          virtualisation.interfaces.enp1s0.vlan = 1;
          networking = {
            useNetworkd = networkd;
            useDHCP = false;
            firewall.logReversePathDrops = true; # to debug firewall rules
            # reverse path filtering rules for the macvlan interface seem
            # to be incorrect, causing the test to fail. Disable temporarily.
            firewall.checkReversePath = false;
            macvlans.macvlan.interface = "enp1s0";
            interfaces.enp1s0.useDHCP = true;
            interfaces.macvlan.useDHCP = true;
          };
        };
      testScript = ''
        start_all()

        with subtest("Wait for networking to come up"):
            client.wait_for_unit("network.target")
            router.wait_for_unit("network.target")

        with subtest("Wait until we have an ip address on each interface"):
            client.wait_until_succeeds("ip addr show dev enp1s0 | grep -q '192.168.1'")
            client.wait_until_succeeds("ip addr show dev macvlan | grep -q '192.168.1'")

        with subtest("Print lots of diagnostic information"):
            router.log("**********************************************")
            router.succeed("ip addr >&2")
            router.succeed("ip route >&2")
            router.execute("iptables-save >&2")
            client.log("==============================================")
            client.succeed("ip addr >&2")
            client.succeed("ip route >&2")
            client.execute("iptables-save >&2")
            client.log("##############################################")

        with subtest("Test macvlan creates routable ips"):
            client.wait_until_succeeds("ping -c 1 192.168.1.1")
            client.wait_until_succeeds("ping -c 1 192.168.1.2")
            client.wait_until_succeeds("ping -c 1 192.168.1.3")

            router.wait_until_succeeds("ping -c 1 192.168.1.1")
            router.wait_until_succeeds("ping -c 1 192.168.1.2")
            router.wait_until_succeeds("ping -c 1 192.168.1.3")
      '';
    };
    fou = {
      name = "foo-over-udp";
      nodes.machine = clientConfig {
        virtualisation.interfaces.enp1s0.vlan = 1;
        networking = {
          interfaces.enp1s0.ipv4.addresses = [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
          fooOverUDP = {
            fou1 = {
              port = 9001;
            };
            fou2 = {
              port = 9002;
              protocol = 41;
            };
            fou3 = lib.mkIf (!networkd) {
              port = 9003;
              local.address = "192.168.1.1";
            };
            fou4 = lib.mkIf (!networkd) {
              port = 9004;
              local = {
                address = "192.168.1.1";
                dev = "enp1s0";
              };
            };
          };
        };
        systemd.services = {
          fou3-fou-encap.after = lib.optional (!networkd) "network-addresses-enp1s0.service";
        };
      };
      testScript =
        ''
          import json

          machine.wait_for_unit("network.target")
          fous = json.loads(machine.succeed("ip -json fou show"))
          assert {"port": 9001, "gue": None, "family": "inet"} in fous, "fou1 exists"
          assert {"port": 9002, "ipproto": 41, "family": "inet"} in fous, "fou2 exists"
        ''
        + lib.optionalString (!networkd) ''
          assert {
              "port": 9003,
              "gue": None,
              "family": "inet",
              "local": "192.168.1.1",
          } in fous, "fou3 exists"
          assert {
              "port": 9004,
              "gue": None,
              "family": "inet",
              "local": "192.168.1.1",
              "dev": "enp1s0",
          } in fous, "fou4 exists"
        '';
    };
    sit =
      let
        node =
          {
            address4,
            remote,
            address6,
          }:
          { pkgs, ... }:
          {
            virtualisation.interfaces.enp1s0.vlan = 1;
            networking = {
              useNetworkd = networkd;
              useDHCP = false;
              sits.sit = {
                inherit remote;
                local = address4;
                dev = "enp1s0";
              };
              interfaces.enp1s0.ipv4.addresses = lib.mkOverride 0 [
                {
                  address = address4;
                  prefixLength = 24;
                }
              ];
              interfaces.sit.ipv6.addresses = lib.mkOverride 0 [
                {
                  address = address6;
                  prefixLength = 64;
                }
              ];
            };
          };
      in
      {
        name = "Sit";
        # note on firewalling: the two nodes are explicitly asymmetric.
        # client1 sends SIT packets in UDP, but accepts only proto-41 incoming.
        # client2 does the reverse, sending in proto-41 and accepting only UDP incoming.
        # that way we'll notice when either SIT itself or FOU breaks.
        nodes.client1 =
          args@{ pkgs, ... }:
          lib.mkMerge [
            (node {
              address4 = "192.168.1.1";
              remote = "192.168.1.2";
              address6 = "fc00::1";
            } args)
            {
              networking = {
                firewall.extraCommands = "iptables -A INPUT -p 41 -j ACCEPT";
                sits.sit.encapsulation = {
                  type = "fou";
                  port = 9001;
                };
              };
            }
          ];
        nodes.client2 =
          args@{ pkgs, ... }:
          lib.mkMerge [
            (node {
              address4 = "192.168.1.2";
              remote = "192.168.1.1";
              address6 = "fc00::2";
            } args)
            {
              networking = {
                firewall.allowedUDPPorts = [ 9001 ];
                fooOverUDP.fou1 = {
                  port = 9001;
                  protocol = 41;
                };
              };
            }
          ];
        testScript = ''
          start_all()

          with subtest("Wait for networking to be configured"):
              client1.wait_for_unit("network.target")
              client2.wait_for_unit("network.target")

              # Print diagnostic information
              client1.succeed("ip addr >&2")
              client2.succeed("ip addr >&2")

          with subtest("Test ipv6"):
              client1.wait_until_succeeds("ping -c 1 fc00::1")
              client1.wait_until_succeeds("ping -c 1 fc00::2")

              client2.wait_until_succeeds("ping -c 1 fc00::1")
              client2.wait_until_succeeds("ping -c 1 fc00::2")
        '';
      };
    gre =
      let
        node =
          { ... }:
          {
            networking = {
              useNetworkd = networkd;
              useDHCP = false;
              firewall.extraCommands = "ip6tables -A nixos-fw -p gre -j nixos-fw-accept";
            };
          };
      in
      {
        name = "GRE";
        nodes.client1 =
          args@{ pkgs, ... }:
          lib.mkMerge [
            (node args)
            {
              virtualisation.vlans = [
                1
                2
                4
              ];
              networking = {
                greTunnels = {
                  greTunnel = {
                    local = "192.168.2.1";
                    remote = "192.168.2.2";
                    dev = "eth2";
                    ttl = 225;
                    type = "tap";
                  };
                  gre6Tunnel = {
                    local = "fd00:1234:5678:4::1";
                    remote = "fd00:1234:5678:4::2";
                    dev = "eth3";
                    ttl = 255;
                    type = "tun6";
                  };
                };
                bridges.bridge.interfaces = [
                  "greTunnel"
                  "eth1"
                ];
                interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [ ];
                interfaces.eth1.ipv6.addresses = lib.mkOverride 0 [ ];
                interfaces.bridge.ipv4.addresses = lib.mkOverride 0 [
                  {
                    address = "192.168.1.1";
                    prefixLength = 24;
                  }
                ];
                interfaces.eth3.ipv6.addresses = [
                  {
                    address = "fd00:1234:5678:4::1";
                    prefixLength = 64;
                  }
                ];
                interfaces.gre6Tunnel.ipv6.addresses = lib.mkOverride 0 [
                  {
                    address = "fc00::1";
                    prefixLength = 64;
                  }
                ];
              };
            }
          ];
        nodes.client2 =
          args@{ pkgs, ... }:
          lib.mkMerge [
            (node args)
            {
              virtualisation.vlans = [
                2
                3
                4
              ];
              networking = {
                greTunnels = {
                  greTunnel = {
                    local = "192.168.2.2";
                    remote = "192.168.2.1";
                    dev = "eth1";
                    ttl = 225;
                    type = "tap";
                  };
                  gre6Tunnel = {
                    local = "fd00:1234:5678:4::2";
                    remote = "fd00:1234:5678:4::1";
                    dev = "eth3";
                    ttl = 255;
                    type = "tun6";
                  };
                };
                bridges.bridge.interfaces = [
                  "greTunnel"
                  "eth2"
                ];
                interfaces.eth2.ipv4.addresses = lib.mkOverride 0 [ ];
                interfaces.eth2.ipv6.addresses = lib.mkOverride 0 [ ];
                interfaces.bridge.ipv4.addresses = lib.mkOverride 0 [
                  {
                    address = "192.168.1.2";
                    prefixLength = 24;
                  }
                ];
                interfaces.eth3.ipv6.addresses = [
                  {
                    address = "fd00:1234:5678:4::2";
                    prefixLength = 64;
                  }
                ];
                interfaces.gre6Tunnel.ipv6.addresses = lib.mkOverride 0 [
                  {
                    address = "fc00::2";
                    prefixLength = 64;
                  }
                ];
              };
            }
          ];
        testScript = ''
          import json
          start_all()

          with subtest("Wait for networking to be configured"):
              client1.wait_for_unit("network.target")
              client2.wait_for_unit("network.target")

              # Print diagnostic information
              client1.succeed("ip addr >&2")
              client2.succeed("ip addr >&2")

          with subtest("Test GRE tunnel bridge over VLAN"):
              client1.wait_until_succeeds("ping -c 1 192.168.1.2")

              client2.wait_until_succeeds("ping -c 1 192.168.1.1")

              client1.wait_until_succeeds("ping -c 1 fc00::2")

              client2.wait_until_succeeds("ping -c 1 fc00::1")

          with subtest("Test GRE tunnel TTL"):
              links = json.loads(client1.succeed("ip -details -json link show greTunnel"))
              assert links[0]['linkinfo']['info_data']['ttl'] == 225, "ttl not set for greTunnel"

              links = json.loads(client2.succeed("ip -details -json link show gre6Tunnel"))
              assert links[0]['linkinfo']['info_data']['ttl'] == 255, "ttl not set for gre6Tunnel"
        '';
      };
    vlan =
      let
        node = address: {
          networking = {
            useNetworkd = networkd;
            useDHCP = false;
            vlans.vlan = {
              id = 1;
              interface = "eth0";
            };
            interfaces.eth0.ipv4.addresses = lib.mkOverride 0 [ ];
            interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [ ];
            interfaces.vlan.ipv4.addresses = lib.mkOverride 0 [
              {
                inherit address;
                prefixLength = 24;
              }
            ];
          };
        };
      in
      {
        name = "vlan";
        nodes.client1 = node "192.168.1.1";
        nodes.client2 = node "192.168.1.2";
        testScript = ''
          start_all()

          with subtest("Wait for networking to be configured"):
              client1.wait_for_unit("network.target")
              client2.wait_for_unit("network.target")

          with subtest("Test vlan is setup"):
              client1.succeed("ip addr show dev vlan >&2")
              client2.succeed("ip addr show dev vlan >&2")
        '';
      };
    vlan-ping =
      let
        baseIP = number: "10.10.10.${number}";
        vlanIP = number: "10.1.1.${number}";
        baseInterface = "enp1s0";
        vlanInterface = "vlan42";
        node = number: {
          virtualisation.interfaces.enp1s0.vlan = 1;
          networking = {
            #useNetworkd = networkd;
            useDHCP = false;
            vlans.${vlanInterface} = {
              id = 42;
              interface = baseInterface;
            };
            interfaces.${baseInterface}.ipv4.addresses = lib.mkOverride 0 [
              {
                address = baseIP number;
                prefixLength = 24;
              }
            ];
            interfaces.${vlanInterface}.ipv4.addresses = lib.mkOverride 0 [
              {
                address = vlanIP number;
                prefixLength = 24;
              }
            ];
          };
        };

        serverNodeNum = "1";
        clientNodeNum = "2";

      in
      {
        name = "vlan-ping";
        nodes.server = node serverNodeNum;
        nodes.client = node clientNodeNum;
        testScript = ''
          start_all()

          with subtest("Wait for networking to be configured"):
              server.wait_for_unit("network.target")
              client.wait_for_unit("network.target")

          with subtest("Test ping on base interface in setup"):
              client.succeed("ping -I ${baseInterface} -c 1 ${baseIP serverNodeNum}")
              server.succeed("ping -I ${baseInterface} -c 1 ${baseIP clientNodeNum}")

          with subtest("Test ping on vlan subinterface in setup"):
              client.succeed("ping -I ${vlanInterface} -c 1 ${vlanIP serverNodeNum}")
              server.succeed("ping -I ${vlanInterface} -c 1 ${vlanIP clientNodeNum}")
        '';
      };
    virtual = {
      name = "Virtual";
      nodes.machine = {
        networking.useNetworkd = networkd;
        networking.useDHCP = false;
        networking.interfaces.tap0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.1";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "2001:1470:fffd:2096::";
              prefixLength = 64;
            }
          ];
          virtual = true;
          mtu = 1342;
          macAddress = "02:de:ad:be:ef:01";
        };
        networking.interfaces.tun0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "2001:1470:fffd:2097::";
              prefixLength = 64;
            }
          ];
          virtual = true;
          mtu = 1343;
        };
      };

      testScript =
        ''
          targetList = """
          tap0: tap persist user 0
          tun0: tun persist user 0
          """.strip()

          with subtest("Wait for networking to come up"):
              machine.start()
              machine.wait_for_unit("network.target")

          with subtest("Test interfaces set up"):
              list = machine.succeed("ip tuntap list | sort").strip()
              assert (
                  list == targetList
              ), """
              The list of virtual interfaces does not match the expected one:
              Result:
                {}
              Expected:
                {}
              """.format(
                  list, targetList
              )
          with subtest("Test MTU and MAC Address are configured"):
              machine.wait_until_succeeds("ip link show dev tap0 | grep 'mtu 1342'")
              machine.wait_until_succeeds("ip link show dev tun0 | grep 'mtu 1343'")
              assert "02:de:ad:be:ef:01" in machine.succeed("ip link show dev tap0")
        '' # network-addresses-* only exist in scripted networking
        + lib.optionalString (!networkd) ''
          with subtest("Test interfaces' addresses clean up"):
              machine.succeed("systemctl stop network-addresses-tap0")
              machine.sleep(10)
              machine.succeed("systemctl stop network-addresses-tun0")
              machine.sleep(10)
              residue = machine.succeed("ip tuntap list | sort").strip()
              assert (
                  residue == targetList
              ), "Some virtual interface has been removed:\n{}".format(residue)
              assert "192.168.1.1" not in machine.succeed("ip address show dev tap0"), "tap0 interface address has not been removed"
              assert "192.168.1.2" not in machine.succeed("ip address show dev tun0"), "tun0 interface address has not been removed"

          with subtest("Test interfaces clean up"):
              machine.succeed("systemctl stop tap0-netdev")
              machine.sleep(10)
              machine.succeed("systemctl stop tun0-netdev")
              machine.sleep(10)
              residue = machine.succeed("ip tuntap list")
              assert (
                  residue == ""
              ), "Some virtual interface has not been properly cleaned:\n{}".format(residue)
        '';
    };
    privacy = {
      name = "Privacy";
      nodes.router = {
        virtualisation.interfaces.enp1s0.vlan = 1;
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.enp1s0.ipv6.addresses = lib.singleton {
            address = "fd00:1234:5678:1::1";
            prefixLength = 64;
          };
        };
        services.radvd = {
          enable = true;
          config = ''
            interface enp1s0 {
              AdvSendAdvert on;
              AdvManagedFlag on;
              AdvOtherConfigFlag on;

              prefix fd00:1234:5678:1::/64 {
                AdvAutonomous on;
                AdvOnLink on;
              };
            };
          '';
        };
      };
      nodes.client_with_privacy = {
        virtualisation.interfaces.enp1s0.vlan = 1;
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.enp1s0 = {
            tempAddress = "default";
            ipv4.addresses = lib.mkOverride 0 [ ];
            ipv6.addresses = lib.mkOverride 0 [ ];
            useDHCP = true;
          };
        };
      };
      nodes.client = {
        virtualisation.interfaces.enp1s0.vlan = 1;
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.enp1s0 = {
            tempAddress = "enabled";
            ipv4.addresses = lib.mkOverride 0 [ ];
            ipv6.addresses = lib.mkOverride 0 [ ];
            useDHCP = true;
          };
        };
      };
      testScript = ''
        start_all()

        client.wait_for_unit("network.target")
        client_with_privacy.wait_for_unit("network.target")
        router.systemctl("start network-online.target")
        router.wait_for_unit("network-online.target")

        with subtest("Wait until we have an ip address"):
            client_with_privacy.wait_until_succeeds(
                "ip addr show dev enp1s0 | grep -q 'fd00:1234:5678:1:'"
            )
            client.wait_until_succeeds("ip addr show dev enp1s0 | grep -q 'fd00:1234:5678:1:'")

        with subtest("Test vlan 1"):
            client_with_privacy.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")
            client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")

        with subtest("Test address used is temporary"):
            client_with_privacy.wait_until_succeeds(
                "! ip route get fd00:1234:5678:1::1 | grep -q ':[a-f0-9]*ff:fe[a-f0-9]*:'"
            )

        with subtest("Test address used is EUI-64"):
            client.wait_until_succeeds(
                "ip route get fd00:1234:5678:1::1 | grep -q ':[a-f0-9]*ff:fe[a-f0-9]*:'"
            )
      '';
    };
    routes = {
      name = "routes";
      nodes.machine = {
        networking.useNetworkd = networkd;
        networking.useDHCP = false;
        networking.interfaces.eth0 = {
          ipv4.addresses = [
            {
              address = "192.168.1.2";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "2001:1470:fffd:2097::";
              prefixLength = 64;
            }
          ];
          ipv6.routes = [
            {
              address = "fdfd:b3f0::";
              prefixLength = 48;
            }
            {
              address = "2001:1470:fffd:2098::";
              prefixLength = 64;
              via = "fdfd:b3f0::1";
            }
          ];
          ipv4.routes = [
            {
              address = "10.0.0.0";
              prefixLength = 16;
              options = {
                mtu = "1500";
                # Explicitly set scope because iproute and systemd-networkd
                # disagree on what the scope should be
                # if the type is the default "unicast"
                scope = "link";
              };
            }
            {
              address = "192.168.2.0";
              prefixLength = 24;
              via = "192.168.1.1";
            }
          ];
        };
        virtualisation.vlans = [ ];
      };

      testScript =
        ''
          targetIPv4Table = [
              "10.0.0.0/16 proto static scope link mtu 1500",
              "192.168.1.0/24 proto kernel scope link src 192.168.1.2",
              "192.168.2.0/24 via 192.168.1.1 proto static",
          ]

          targetIPv6Table = [
              "2001:1470:fffd:2097::/64 proto kernel metric 256 pref medium",
              "2001:1470:fffd:2098::/64 via fdfd:b3f0::1 proto static metric 1024 pref medium",
              "fdfd:b3f0::/48 proto static metric 1024 pref medium",
          ]

          machine.start()
          machine.wait_for_unit("network.target")

          with subtest("test routing tables"):
              ipv4Table = machine.succeed("ip -4 route list dev eth0 | head -n3").strip()
              ipv6Table = machine.succeed("ip -6 route list dev eth0 | head -n3").strip()
              assert [
                  l.strip() for l in ipv4Table.splitlines()
              ] == targetIPv4Table, """
                The IPv4 routing table does not match the expected one:
                  Result:
                    {}
                  Expected:
                    {}
                """.format(
                  ipv4Table, targetIPv4Table
              )
              assert [
                  l.strip() for l in ipv6Table.splitlines()
              ] == targetIPv6Table, """
                The IPv6 routing table does not match the expected one:
                  Result:
                    {}
                  Expected:
                    {}
                """.format(
                  ipv6Table, targetIPv6Table
              )

        ''
        + lib.optionalString (!networkd) ''
          with subtest("test clean-up of the tables"):
              machine.succeed("systemctl stop network-addresses-eth0")
              ipv4Residue = machine.succeed("ip -4 route list dev eth0 | head -n-3").strip()
              ipv6Residue = machine.succeed("ip -6 route list dev eth0 | head -n-3").strip()
              assert (
                  ipv4Residue == ""
              ), "The IPv4 routing table has not been properly cleaned:\n{}".format(ipv4Residue)
              assert (
                  ipv6Residue == ""
              ), "The IPv6 routing table has not been properly cleaned:\n{}".format(ipv6Residue)
        '';
    };
    rename =
      if networkd then
        {
          name = "RenameInterface";
          nodes.machine = {
            virtualisation.vlans = [ 1 ];
            networking = {
              useNetworkd = networkd;
              useDHCP = false;
            };
            systemd.network.links."10-custom_name" = {
              matchConfig.MACAddress = "52:54:00:12:01:01";
              linkConfig.Name = "custom_name";
            };
          };
          testScript = ''
            machine.succeed("udevadm settle")
            print(machine.succeed("ip link show dev custom_name"))
          '';
        }
      else
        {
          name = "RenameInterface";
          nodes = { };
          testScript = "";
        };
    # even with disabled networkd, systemd.network.links should work
    # (as it's handled by udev, not networkd)
    link = {
      name = "Link";
      nodes.client = {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
        };
        systemd.network.links."50-foo" = {
          matchConfig = {
            Name = "foo";
            Driver = "dummy";
          };
          linkConfig.MTUBytes = "1442";
        };
      };
      testScript = ''
        print(client.succeed("ip l add name foo type dummy"))
        print(client.succeed("stat /etc/systemd/network/50-foo.link"))
        client.succeed("udevadm settle")
        assert "mtu 1442" in client.succeed("ip l show dev foo")
      '';
    };
    wlanInterface =
      let
        testMac = "06:00:00:00:02:00";
      in
      {
        name = "WlanInterface";
        nodes.machine = {
          boot.kernelModules = [ "mac80211_hwsim" ];
          networking.wlanInterfaces = {
            wlan0 = {
              device = "wlan0";
            };
            wap0 = {
              device = "wlan0";
              mac = testMac;
            };
          };
        };
        testScript = ''
          machine.start()
          machine.wait_for_unit("network.target")
          machine.wait_until_succeeds("ip address show wap0 | grep -q ${testMac}")
          machine.fail("ip address show wlan0 | grep -q ${testMac}")
        '';
      };
    naughtyInterfaceNames =
      let
        ifnames = [
          # flags of ip-address
          "home"
          "temporary"
          "optimistic"
          "bridge_slave"
          "flush"
          # flags of ip-route
          "up"
          "type"
          "nomaster"
          "address"
          # other
          "very_loong_name"
          "lowerUpper"
          "-"
        ];
      in
      {
        name = "naughtyInterfaceNames";
        nodes.machine = {
          networking.useNetworkd = networkd;
          networking.bridges = lib.listToAttrs (
            lib.flip builtins.map ifnames (name: {
              inherit name;
              value.interfaces = [ ];
            })
          );
        };
        testScript = ''
          machine.start()
          machine.wait_for_unit("network.target")
          for ifname in ${builtins.toJSON ifnames}:
              machine.wait_until_succeeds(f"ip link show dev '{ifname}' | grep -q '{ifname}'")
        '';
      };
    caseSensitiveRenaming = {
      name = "CaseSensitiveRenaming";
      nodes.machine = {
        virtualisation.interfaces.enCustom.vlan = 11;
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
        };
      };
      testScript = ''
        machine.succeed("udevadm settle")
        print(machine.succeed("ip link show dev enCustom"))
        machine.wait_until_succeeds("ip link show dev enCustom | grep -q 52:54:00:12:0b:01")
      '';
    };
  };

in
lib.mapAttrs (lib.const (
  attrs:
  makeTest (
    attrs
    // {
      name = "${attrs.name}-Networking-${if networkd then "Networkd" else "Scripted"}";
    }
  )
)) testCases
