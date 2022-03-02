{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
# bool: whether to use networkd in the tests
, networkd }:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  qemu-common = import ../lib/qemu-common.nix { inherit (pkgs) lib pkgs; };

  router = { config, pkgs, lib, ... }:
    with pkgs.lib;
    let
      vlanIfs = range 1 (length config.virtualisation.vlans);
    in {
      environment.systemPackages = [ pkgs.iptables ]; # to debug firewall rules
      virtualisation.vlans = [ 1 2 3 ];
      boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
      networking = {
        useDHCP = false;
        useNetworkd = networkd;
        firewall.checkReversePath = true;
        firewall.allowedUDPPorts = [ 547 ];
        interfaces = mkOverride 0 (listToAttrs (forEach vlanIfs (n:
          nameValuePair "eth${toString n}" {
            ipv4.addresses = [ { address = "192.168.${toString n}.1"; prefixLength = 24; } ];
            ipv6.addresses = [ { address = "fd00:1234:5678:${toString n}::1"; prefixLength = 64; } ];
          })));
      };
      services.dhcpd4 = {
        enable = true;
        interfaces = map (n: "eth${toString n}") vlanIfs;
        extraConfig = flip concatMapStrings vlanIfs (n: ''
          subnet 192.168.${toString n}.0 netmask 255.255.255.0 {
            option routers 192.168.${toString n}.1;
            range 192.168.${toString n}.3 192.168.${toString n}.254;
          }
        '')
        ;
        machines = flip map vlanIfs (vlan:
          {
            hostName = "client${toString vlan}";
            ethernetAddress = qemu-common.qemuNicMac vlan 1;
            ipAddress = "192.168.${toString vlan}.2";
          }
        );
      };
      services.radvd = {
        enable = true;
        config = flip concatMapStrings vlanIfs (n: ''
          interface eth${toString n} {
            AdvSendAdvert on;
            AdvManagedFlag on;
            AdvOtherConfigFlag on;

            prefix fd00:1234:5678:${toString n}::/64 {
              AdvAutonomous off;
            };
          };
        '');
      };
      services.dhcpd6 = {
        enable = true;
        interfaces = map (n: "eth${toString n}") vlanIfs;
        extraConfig = ''
          authoritative;
        '' + flip concatMapStrings vlanIfs (n: ''
          subnet6 fd00:1234:5678:${toString n}::/64 {
            range6 fd00:1234:5678:${toString n}::2 fd00:1234:5678:${toString n}::2;
          }
        '');
      };
    };

  testCases = {
    loopback = {
      name = "Loopback";
      machine.networking.useDHCP = false;
      machine.networking.useNetworkd = networkd;
      testScript = ''
        start_all()
        machine.wait_for_unit("network.target")
        loopback_addresses = machine.succeed("ip addr show lo")
        assert "inet 127.0.0.1/8" in loopback_addresses
        assert "inet6 ::1/128" in loopback_addresses
      '';
    };
    static = {
      name = "Static";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          defaultGateway = "192.168.1.1";
          interfaces.eth1.ipv4.addresses = mkOverride 0 [
            { address = "192.168.1.2"; prefixLength = 24; }
            { address = "192.168.1.3"; prefixLength = 32; }
            { address = "192.168.1.10"; prefixLength = 32; }
          ];
          interfaces.eth2.ipv4.addresses = mkOverride 0 [
            { address = "192.168.2.2"; prefixLength = 24; }
          ];
        };
      };
      testScript = { ... }:
        ''
          start_all()

          client.wait_for_unit("network.target")
          router.wait_for_unit("network-online.target")

          with subtest("Make sure dhcpcd is not started"):
              client.fail("systemctl status dhcpcd.service")

          with subtest("Test vlan 1"):
              client.wait_until_succeeds("ping -c 1 192.168.1.1")
              client.wait_until_succeeds("ping -c 1 192.168.1.2")
              client.wait_until_succeeds("ping -c 1 192.168.1.3")
              client.wait_until_succeeds("ping -c 1 192.168.1.10")

              router.wait_until_succeeds("ping -c 1 192.168.1.1")
              router.wait_until_succeeds("ping -c 1 192.168.1.2")
              router.wait_until_succeeds("ping -c 1 192.168.1.3")
              router.wait_until_succeeds("ping -c 1 192.168.1.10")

          with subtest("Test vlan 2"):
              client.wait_until_succeeds("ping -c 1 192.168.2.1")
              client.wait_until_succeeds("ping -c 1 192.168.2.2")

              router.wait_until_succeeds("ping -c 1 192.168.2.1")
              router.wait_until_succeeds("ping -c 1 192.168.2.2")

          with subtest("Test default gateway"):
              router.wait_until_succeeds("ping -c 1 192.168.3.1")
              client.wait_until_succeeds("ping -c 1 192.168.3.1")
        '';
    };
    dhcpSimple = {
      name = "SimpleDHCP";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
          interfaces.eth2 = {
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
        };
      };
      testScript = { ... }:
        ''
          start_all()

          client.wait_for_unit("network.target")
          router.wait_for_unit("network-online.target")

          with subtest("Wait until we have an ip address on each interface"):
              client.wait_until_succeeds("ip addr show dev eth1 | grep -q '192.168.1'")
              client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")
              client.wait_until_succeeds("ip addr show dev eth2 | grep -q '192.168.2'")
              client.wait_until_succeeds("ip addr show dev eth2 | grep -q 'fd00:1234:5678:2:'")

          with subtest("Test vlan 1"):
              client.wait_until_succeeds("ping -c 1 192.168.1.1")
              client.wait_until_succeeds("ping -c 1 192.168.1.2")
              client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")
              client.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::2")

              router.wait_until_succeeds("ping -c 1 192.168.1.1")
              router.wait_until_succeeds("ping -c 1 192.168.1.2")
              router.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::1")
              router.wait_until_succeeds("ping -c 1 fd00:1234:5678:1::2")

          with subtest("Test vlan 2"):
              client.wait_until_succeeds("ping -c 1 192.168.2.1")
              client.wait_until_succeeds("ping -c 1 192.168.2.2")
              client.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::1")
              client.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::2")

              router.wait_until_succeeds("ping -c 1 192.168.2.1")
              router.wait_until_succeeds("ping -c 1 192.168.2.2")
              router.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::1")
              router.wait_until_succeeds("ping -c 1 fd00:1234:5678:2::2")
        '';
    };
    dhcpOneIf = {
      name = "OneInterfaceDHCP";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = mkOverride 0 [ ];
            mtu = 1343;
            useDHCP = true;
          };
          interfaces.eth2.ipv4.addresses = mkOverride 0 [ ];
        };
      };
      testScript = { ... }:
        ''
          start_all()

          with subtest("Wait for networking to come up"):
              client.wait_for_unit("network.target")
              router.wait_for_unit("network.target")

          with subtest("Wait until we have an ip address on each interface"):
              client.wait_until_succeeds("ip addr show dev eth1 | grep -q '192.168.1'")

          with subtest("ensure MTU is set"):
              assert "mtu 1343" in client.succeed("ip link show dev eth1")

          with subtest("Test vlan 1"):
              client.wait_until_succeeds("ping -c 1 192.168.1.1")
              client.wait_until_succeeds("ping -c 1 192.168.1.2")

              router.wait_until_succeeds("ping -c 1 192.168.1.1")
              router.wait_until_succeeds("ping -c 1 192.168.1.2")

          with subtest("Test vlan 2"):
              client.wait_until_succeeds("ping -c 1 192.168.2.1")
              client.fail("ping -c 1 192.168.2.2")

              router.wait_until_succeeds("ping -c 1 192.168.2.1")
              router.fail("ping -c 1 192.168.2.2")
        '';
    };
    bond = let
      node = address: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          bonds.bond0 = {
            interfaces = [ "eth1" "eth2" ];
            driverOptions.mode = "802.3ad";
          };
          interfaces.eth1.ipv4.addresses = mkOverride 0 [ ];
          interfaces.eth2.ipv4.addresses = mkOverride 0 [ ];
          interfaces.bond0.ipv4.addresses = mkOverride 0
            [ { inherit address; prefixLength = 30; } ];
        };
      };
    in {
      name = "Bond";
      nodes.client1 = node "192.168.1.1";
      nodes.client2 = node "192.168.1.2";
      testScript = { ... }:
        ''
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
    bridge = let
      node = { address, vlan }: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ vlan ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = mkOverride 0
            [ { inherit address; prefixLength = 24; } ];
        };
      };
    in {
      name = "Bridge";
      nodes.client1 = node { address = "192.168.1.2"; vlan = 1; };
      nodes.client2 = node { address = "192.168.1.3"; vlan = 2; };
      nodes.router = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          bridges.bridge.interfaces = [ "eth1" "eth2" ];
          interfaces.eth1.ipv4.addresses = mkOverride 0 [ ];
          interfaces.eth2.ipv4.addresses = mkOverride 0 [ ];
          interfaces.bridge.ipv4.addresses = mkOverride 0
            [ { address = "192.168.1.1"; prefixLength = 24; } ];
        };
      };
      testScript = { ... }:
        ''
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
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        environment.systemPackages = [ pkgs.iptables ]; # to debug firewall rules
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          firewall.logReversePathDrops = true; # to debug firewall rules
          # reverse path filtering rules for the macvlan interface seem
          # to be incorrect, causing the test to fail. Disable temporarily.
          firewall.checkReversePath = false;
          macvlans.macvlan.interface = "eth1";
          interfaces.eth1 = {
            ipv4.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
          interfaces.macvlan = {
            useDHCP = true;
          };
        };
      };
      testScript = { ... }:
        ''
          start_all()

          with subtest("Wait for networking to come up"):
              client.wait_for_unit("network.target")
              router.wait_for_unit("network.target")

          with subtest("Wait until we have an ip address on each interface"):
              client.wait_until_succeeds("ip addr show dev eth1 | grep -q '192.168.1'")
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
      nodes.machine = { ... }: {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1.ipv4.addresses = mkOverride 0
            [ { address = "192.168.1.1"; prefixLength = 24; } ];
          fooOverUDP = {
            fou1 = { port = 9001; };
            fou2 = { port = 9002; protocol = 41; };
            fou3 = mkIf (!networkd)
              { port = 9003; local.address = "192.168.1.1"; };
            fou4 = mkIf (!networkd)
              { port = 9004; local = { address = "192.168.1.1"; dev = "eth1"; }; };
          };
        };
        systemd.services = {
          fou3-fou-encap.after = optional (!networkd) "network-addresses-eth1.service";
        };
      };
      testScript = { ... }:
        ''
          import json

          machine.wait_for_unit("network.target")
          fous = json.loads(machine.succeed("ip -json fou show"))
          assert {"port": 9001, "gue": None, "family": "inet"} in fous, "fou1 exists"
          assert {"port": 9002, "ipproto": 41, "family": "inet"} in fous, "fou2 exists"
        '' + optionalString (!networkd) ''
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
              "dev": "eth1",
          } in fous, "fou4 exists"
        '';
    };
    sit = let
      node = { address4, remote, address6 }: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          sits.sit = {
            inherit remote;
            local = address4;
            dev = "eth1";
          };
          interfaces.eth1.ipv4.addresses = mkOverride 0
            [ { address = address4; prefixLength = 24; } ];
          interfaces.sit.ipv6.addresses = mkOverride 0
            [ { address = address6; prefixLength = 64; } ];
        };
      };
    in {
      name = "Sit";
      # note on firewalling: the two nodes are explicitly asymmetric.
      # client1 sends SIT packets in UDP, but accepts only proto-41 incoming.
      # client2 does the reverse, sending in proto-41 and accepting only UDP incoming.
      # that way we'll notice when either SIT itself or FOU breaks.
      nodes.client1 = args@{ pkgs, ... }:
        mkMerge [
          (node { address4 = "192.168.1.1"; remote = "192.168.1.2"; address6 = "fc00::1"; } args)
          {
            networking = {
              firewall.extraCommands = "iptables -A INPUT -p 41 -j ACCEPT";
              sits.sit.encapsulation = { type = "fou"; port = 9001; };
            };
          }
        ];
      nodes.client2 = args@{ pkgs, ... }:
        mkMerge [
          (node { address4 = "192.168.1.2"; remote = "192.168.1.1"; address6 = "fc00::2"; } args)
          {
            networking = {
              firewall.allowedUDPPorts = [ 9001 ];
              fooOverUDP.fou1 = { port = 9001; protocol = 41; };
            };
          }
        ];
      testScript = { ... }:
        ''
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
    gre = let
      node = { pkgs, ... }: with pkgs.lib; {
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
        };
      };
    in {
      name = "GRE";
      nodes.client1 = args@{ pkgs, ... }:
        mkMerge [
          (node args)
          {
            virtualisation.vlans = [ 1 2 ];
            networking = {
              greTunnels = {
                greTunnel = {
                  local = "192.168.2.1";
                  remote = "192.168.2.2";
                  dev = "eth2";
                  type = "tap";
                };
              };
              bridges.bridge.interfaces = [ "greTunnel" "eth1" ];
              interfaces.eth1.ipv4.addresses = mkOverride 0 [];
              interfaces.bridge.ipv4.addresses = mkOverride 0 [
                { address = "192.168.1.1"; prefixLength = 24; }
              ];
            };
          }
        ];
      nodes.client2 = args@{ pkgs, ... }:
        mkMerge [
          (node args)
          {
            virtualisation.vlans = [ 2 3 ];
            networking = {
              greTunnels = {
                greTunnel = {
                  local = "192.168.2.2";
                  remote = "192.168.2.1";
                  dev = "eth1";
                  type = "tap";
                };
              };
              bridges.bridge.interfaces = [ "greTunnel" "eth2" ];
              interfaces.eth2.ipv4.addresses = mkOverride 0 [];
              interfaces.bridge.ipv4.addresses = mkOverride 0 [
                { address = "192.168.1.2"; prefixLength = 24; }
              ];
            };
          }
        ];
      testScript = { ... }:
        ''
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
        '';
    };
    vlan = let
      node = address: { pkgs, ... }: with pkgs.lib; {
        #virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          vlans.vlan = {
            id = 1;
            interface = "eth0";
          };
          interfaces.eth0.ipv4.addresses = mkOverride 0 [ ];
          interfaces.eth1.ipv4.addresses = mkOverride 0 [ ];
          interfaces.vlan.ipv4.addresses = mkOverride 0
            [ { inherit address; prefixLength = 24; } ];
        };
      };
    in {
      name = "vlan";
      nodes.client1 = node "192.168.1.1";
      nodes.client2 = node "192.168.1.2";
      testScript = { ... }:
        ''
          start_all()

          with subtest("Wait for networking to be configured"):
              client1.wait_for_unit("network.target")
              client2.wait_for_unit("network.target")

          with subtest("Test vlan is setup"):
              client1.succeed("ip addr show dev vlan >&2")
              client2.succeed("ip addr show dev vlan >&2")
        '';
    };
    virtual = {
      name = "Virtual";
      machine = {
        networking.useNetworkd = networkd;
        networking.useDHCP = false;
        networking.interfaces.tap0 = {
          ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2096::"; prefixLength = 64; } ];
          virtual = true;
          mtu = 1342;
          macAddress = "02:de:ad:be:ef:01";
        };
        networking.interfaces.tun0 = {
          ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2097::"; prefixLength = 64; } ];
          virtual = true;
          mtu = 1343;
        };
      };

      testScript = ''
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
      + optionalString (!networkd) ''
        with subtest("Test interfaces clean up"):
            machine.succeed("systemctl stop network-addresses-tap0")
            machine.sleep(10)
            machine.succeed("systemctl stop network-addresses-tun0")
            machine.sleep(10)
            residue = machine.succeed("ip tuntap list")
            assert (
                residue == ""
            ), "Some virtual interface has not been properly cleaned:\n{}".format(residue)
      '';
    };
    privacy = {
      name = "Privacy";
      nodes.router = { ... }: {
        virtualisation.vlans = [ 1 ];
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1.ipv6.addresses = singleton {
            address = "fd00:1234:5678:1::1";
            prefixLength = 64;
          };
        };
        services.radvd = {
          enable = true;
          config = ''
            interface eth1 {
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
      nodes.client_with_privacy = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1 = {
            tempAddress = "default";
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
        };
      };
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
          interfaces.eth1 = {
            tempAddress = "enabled";
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
        };
      };
      testScript = { ... }:
        ''
          start_all()

          client.wait_for_unit("network.target")
          client_with_privacy.wait_for_unit("network.target")
          router.wait_for_unit("network-online.target")

          with subtest("Wait until we have an ip address"):
              client_with_privacy.wait_until_succeeds(
                  "ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'"
              )
              client.wait_until_succeeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'")

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
      machine = {
        networking.useNetworkd = networkd;
        networking.useDHCP = false;
        networking.interfaces.eth0 = {
          ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2097::"; prefixLength = 64; } ];
          ipv6.routes = [
            { address = "fdfd:b3f0::"; prefixLength = 48; }
            { address = "2001:1470:fffd:2098::"; prefixLength = 64; via = "fdfd:b3f0::1"; }
          ];
          ipv4.routes = [
            { address = "10.0.0.0"; prefixLength = 16; options = {
              mtu = "1500";
              # Explicitly set scope because iproute and systemd-networkd
              # disagree on what the scope should be
              # if the type is the default "unicast"
              scope = "link";
            }; }
            { address = "192.168.2.0"; prefixLength = 24; via = "192.168.1.1"; }
          ];
        };
        virtualisation.vlans = [ ];
      };

      testScript = ''
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

      '' + optionalString (!networkd) ''
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
    rename = {
      name = "RenameInterface";
      machine = { pkgs, ... }: {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = false;
        };
      } //
      (if networkd
       then { systemd.network.links."10-custom_name" = {
                matchConfig.MACAddress = "52:54:00:12:01:01";
                linkConfig.Name = "custom_name";
              };
            }
       else { services.udev.initrdRules = ''
               SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="52:54:00:12:01:01", KERNEL=="eth*", NAME="custom_name"
              '';
            });
      testScript = ''
        machine.succeed("udevadm settle")
        print(machine.succeed("ip link show dev custom_name"))
      '';
    };
    # even with disabled networkd, systemd.network.links should work
    # (as it's handled by udev, not networkd)
    link = {
      name = "Link";
      nodes.client = { pkgs, ... }: {
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
    wlanInterface = let
      testMac = "06:00:00:00:02:00";
    in {
      name = "WlanInterface";
      machine = { pkgs, ... }: {
        boot.kernelModules = [ "mac80211_hwsim" ];
        networking.wlanInterfaces = {
          wlan0 = { device = "wlan0"; };
          wap0 = { device = "wlan0"; mac = testMac; };
        };
      };
      testScript = ''
        machine.start()
        machine.wait_for_unit("network.target")
        machine.wait_until_succeeds("ip address show wap0 | grep -q ${testMac}")
        machine.fail("ip address show wlan0 | grep -q ${testMac}")
      '';
    };
  };

in mapAttrs (const (attrs: makeTest (attrs // {
  name = "${attrs.name}-Networking-${if networkd then "Networkd" else "Scripted"}";
}))) testCases
