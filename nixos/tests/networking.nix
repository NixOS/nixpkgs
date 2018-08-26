{ system ? builtins.currentSystem
# bool: whether to use networkd in the tests
, networkd }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  router = { config, pkgs, ... }:
    with pkgs.lib;
    let
      vlanIfs = range 1 (length config.virtualisation.vlans);
    in {
      virtualisation.vlans = [ 1 2 3 ];
      boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
      networking = {
        useDHCP = false;
        useNetworkd = networkd;
        firewall.allowPing = true;
        firewall.checkReversePath = true;
        firewall.allowedUDPPorts = [ 547 ];
        interfaces = mkOverride 0 (listToAttrs (flip map vlanIfs (n:
          nameValuePair "eth${toString n}" {
            ipv4.addresses = [ { address = "192.168.${toString n}.1"; prefixLength = 24; } ];
            ipv6.addresses = [ { address = "fd00:1234:5678:${toString n}::1"; prefixLength = 64; } ];
          })));
      };
      services.dhcpd4 = {
        enable = true;
        interfaces = map (n: "eth${toString n}") vlanIfs;
        extraConfig = ''
          authoritative;
        '' + flip concatMapStrings vlanIfs (n: ''
          subnet 192.168.${toString n}.0 netmask 255.255.255.0 {
            option routers 192.168.${toString n}.1;
            # XXX: technically it's _not guaranteed_ that IP addresses will be
            # issued from the first item in range onwards! We assume that in
            # our tests however.
            range 192.168.${toString n}.2 192.168.${toString n}.254;
          }
        '');
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
      machine.networking.useNetworkd = networkd;
      testScript = ''
        startAll;
        $machine->waitForUnit("network.target");
        $machine->succeed("ip addr show lo | grep -q 'inet 127.0.0.1/8 '");
        $machine->succeed("ip addr show lo | grep -q 'inet6 ::1/128 '");
      '';
    };
    static = {
      name = "Static";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
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
          startAll;

          $client->waitForUnit("network.target");
          $router->waitForUnit("network-online.target");

          # Make sure dhcpcd is not started
          $client->fail("systemctl status dhcpcd.service");

          # Test vlan 1
          $client->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.3");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.10");

          $router->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.3");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.10");

          # Test vlan 2
          $client->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.2.2");

          $router->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.2.2");

          # Test default gateway
          $router->waitUntilSucceeds("ping -c 1 192.168.3.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.3.1");
        '';
    };
    dhcpSimple = {
      name = "SimpleDHCP";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = true;
          interfaces.eth1 = {
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
          };
          interfaces.eth2 = {
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
          };
        };
      };
      testScript = { ... }:
        ''
          startAll;

          $client->waitForUnit("network.target");
          $router->waitForUnit("network-online.target");

          # Wait until we have an ip address on each interface
          $client->waitUntilSucceeds("ip addr show dev eth1 | grep -q '192.168.1'");
          $client->waitUntilSucceeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'");
          $client->waitUntilSucceeds("ip addr show dev eth2 | grep -q '192.168.2'");
          $client->waitUntilSucceeds("ip addr show dev eth2 | grep -q 'fd00:1234:5678:2:'");

          # Test vlan 1
          $client->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $client->waitUntilSucceeds("ping -c 1 fd00:1234:5678:1::1");
          $client->waitUntilSucceeds("ping -c 1 fd00:1234:5678:1::2");

          $router->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $router->waitUntilSucceeds("ping -c 1 fd00:1234:5678:1::1");
          $router->waitUntilSucceeds("ping -c 1 fd00:1234:5678:1::2");

          # Test vlan 2
          $client->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.2.2");
          $client->waitUntilSucceeds("ping -c 1 fd00:1234:5678:2::1");
          $client->waitUntilSucceeds("ping -c 1 fd00:1234:5678:2::2");

          $router->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.2.2");
          $router->waitUntilSucceeds("ping -c 1 fd00:1234:5678:2::1");
          $router->waitUntilSucceeds("ping -c 1 fd00:1234:5678:2::2");
        '';
    };
    dhcpOneIf = {
      name = "OneInterfaceDHCP";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          interfaces.eth1 = {
            ipv4.addresses = mkOverride 0 [ ];
            useDHCP = true;
          };
          interfaces.eth2.ipv4.addresses = mkOverride 0 [ ];
        };
      };
      testScript = { ... }:
        ''
          startAll;

          # Wait for networking to come up
          $client->waitForUnit("network.target");
          $router->waitForUnit("network.target");

          # Wait until we have an ip address on each interface
          $client->waitUntilSucceeds("ip addr show dev eth1 | grep -q '192.168.1'");

          # Test vlan 1
          $client->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.2");

          $router->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.2");

          # Test vlan 2
          $client->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $client->fail("ping -c 1 192.168.2.2");

          $router->waitUntilSucceeds("ping -c 1 192.168.2.1");
          $router->fail("ping -c 1 192.168.2.2");
        '';
    };
    bond = let
      node = address: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          bonds.bond = {
            interfaces = [ "eth1" "eth2" ];
            driverOptions.mode = "balance-rr";
          };
          interfaces.eth1.ipv4.addresses = mkOverride 0 [ ];
          interfaces.eth2.ipv4.addresses = mkOverride 0 [ ];
          interfaces.bond.ipv4.addresses = mkOverride 0
            [ { inherit address; prefixLength = 30; } ];
        };
      };
    in {
      name = "Bond";
      nodes.client1 = node "192.168.1.1";
      nodes.client2 = node "192.168.1.2";
      testScript = { ... }:
        ''
          startAll;

          # Wait for networking to come up
          $client1->waitForUnit("network.target");
          $client2->waitForUnit("network.target");

          # Test bonding
          $client1->waitUntilSucceeds("ping -c 2 192.168.1.1");
          $client1->waitUntilSucceeds("ping -c 2 192.168.1.2");

          $client2->waitUntilSucceeds("ping -c 2 192.168.1.1");
          $client2->waitUntilSucceeds("ping -c 2 192.168.1.2");
        '';
    };
    bridge = let
      node = { address, vlan }: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ vlan ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
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
          firewall.allowPing = true;
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
          startAll;

          # Wait for networking to come up
          $client1->waitForUnit("network.target");
          $client2->waitForUnit("network.target");
          $router->waitForUnit("network.target");

          # Test bridging
          $client1->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client1->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $client1->waitUntilSucceeds("ping -c 1 192.168.1.3");

          $client2->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client2->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $client2->waitUntilSucceeds("ping -c 1 192.168.1.3");

          $router->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.3");
        '';
    };
    macvlan = {
      name = "MACVLAN";
      nodes.router = router;
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = true;
          macvlans.macvlan.interface = "eth1";
          interfaces.eth1.ipv4.addresses = mkOverride 0 [ ];
        };
      };
      testScript = { ... }:
        ''
          startAll;

          # Wait for networking to come up
          $client->waitForUnit("network.target");
          $router->waitForUnit("network.target");

          # Wait until we have an ip address on each interface
          $client->waitUntilSucceeds("ip addr show dev eth1 | grep -q '192.168.1'");
          $client->waitUntilSucceeds("ip addr show dev macvlan | grep -q '192.168.1'");

          # Print diagnosting information
          $router->succeed("ip addr >&2");
          $client->succeed("ip addr >&2");

          # Test macvlan creates routable ips
          $client->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $client->waitUntilSucceeds("ping -c 1 192.168.1.3");

          $router->waitUntilSucceeds("ping -c 1 192.168.1.1");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.2");
          $router->waitUntilSucceeds("ping -c 1 192.168.1.3");
        '';
    };
    sit = let
      node = { address4, remote, address6 }: { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          firewall.enable = false;
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
      nodes.client1 = node { address4 = "192.168.1.1"; remote = "192.168.1.2"; address6 = "fc00::1"; };
      nodes.client2 = node { address4 = "192.168.1.2"; remote = "192.168.1.1"; address6 = "fc00::2"; };
      testScript = { ... }:
        ''
          startAll;

          # Wait for networking to be configured
          $client1->waitForUnit("network.target");
          $client2->waitForUnit("network.target");

          # Print diagnostic information
          $client1->succeed("ip addr >&2");
          $client2->succeed("ip addr >&2");

          # Test ipv6
          $client1->waitUntilSucceeds("ping -c 1 fc00::1");
          $client1->waitUntilSucceeds("ping -c 1 fc00::2");

          $client2->waitUntilSucceeds("ping -c 1 fc00::1");
          $client2->waitUntilSucceeds("ping -c 1 fc00::2");
        '';
    };
    vlan = let
      node = address: { pkgs, ... }: with pkgs.lib; {
        #virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
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
          startAll;

          # Wait for networking to be configured
          $client1->waitForUnit("network.target");
          $client2->waitForUnit("network.target");

          # Test vlan is setup
          $client1->succeed("ip addr show dev vlan >&2");
          $client2->succeed("ip addr show dev vlan >&2");
        '';
    };
    virtual = {
      name = "Virtual";
      machine = {
        networking.interfaces."tap0" = {
          ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2096::"; prefixLength = 64; } ];
          virtual = true;
        };
        networking.interfaces."tun0" = {
          ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2097::"; prefixLength = 64; } ];
          virtual = true;
        };
      };

      testScript = ''
        my $targetList = <<'END';
        tap0: tap persist user 0
        tun0: tun persist user 0
        END

        # Wait for networking to come up
        $machine->start;
        $machine->waitForUnit("network.target");

        # Test interfaces set up
        my $list = $machine->succeed("ip tuntap list | sort");
        "$list" eq "$targetList" or die(
          "The list of virtual interfaces does not match the expected one:\n",
          "Result:\n", "$list\n",
          "Expected:\n", "$targetList\n"
        );

        # Test interfaces clean up
        $machine->succeed("systemctl stop network-addresses-tap0");
        $machine->succeed("systemctl stop network-addresses-tun0");
        my $residue = $machine->succeed("ip tuntap list");
        $residue eq "" or die(
          "Some virtual interface has not been properly cleaned:\n",
          "$residue\n"
        );
      '';
    };
    privacy = {
      name = "Privacy";
      nodes.router = { ... }: {
        virtualisation.vlans = [ 1 ];
        boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = true;
        networking = {
          useNetworkd = networkd;
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
      nodes.client = { pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          useDHCP = true;
          interfaces.eth1 = {
            preferTempAddress = true;
            ipv4.addresses = mkOverride 0 [ ];
            ipv6.addresses = mkOverride 0 [ ];
          };
        };
      };
      testScript = { ... }:
        ''
          startAll;

          $client->waitForUnit("network.target");
          $router->waitForUnit("network-online.target");

          # Wait until we have an ip address
          $client->waitUntilSucceeds("ip addr show dev eth1 | grep -q 'fd00:1234:5678:1:'");

          # Test vlan 1
          $client->waitUntilSucceeds("ping -c 1 fd00:1234:5678:1::1");

          # Test address used is temporary
          $client->waitUntilSucceeds("! ip route get fd00:1234:5678:1::1 | grep -q ':[a-f0-9]*ff:fe[a-f0-9]*:'");
        '';
    };
    routes = {
      name = "routes";
      machine = {
        networking.useDHCP = false;
        networking.interfaces."eth0" = {
          ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
          ipv6.addresses = [ { address = "2001:1470:fffd:2097::"; prefixLength = 64; } ];
          ipv6.routes = [
            { address = "fdfd:b3f0::"; prefixLength = 48; }
            { address = "2001:1470:fffd:2098::"; prefixLength = 64; via = "fdfd:b3f0::1"; }
          ];
          ipv4.routes = [
            { address = "10.0.0.0"; prefixLength = 16; options = { mtu = "1500"; }; }
            { address = "192.168.2.0"; prefixLength = 24; via = "192.168.1.1"; }
          ];
        };
        virtualisation.vlans = [ ];
      };

      testScript = ''
        my $targetIPv4Table = <<'END';
        10.0.0.0/16 proto static scope link mtu 1500 
        192.168.1.0/24 proto kernel scope link src 192.168.1.2 
        192.168.2.0/24 via 192.168.1.1 proto static 
        END

        my $targetIPv6Table = <<'END';
        2001:1470:fffd:2097::/64 proto kernel metric 256 pref medium
        2001:1470:fffd:2098::/64 via fdfd:b3f0::1 proto static metric 1024 pref medium
        fdfd:b3f0::/48 proto static metric 1024 pref medium
        END

        $machine->start;
        $machine->waitForUnit("network.target");

        # test routing tables
        my $ipv4Table = $machine->succeed("ip -4 route list dev eth0 | head -n3");
        my $ipv6Table = $machine->succeed("ip -6 route list dev eth0 | head -n3");
        "$ipv4Table" eq "$targetIPv4Table" or die(
          "The IPv4 routing table does not match the expected one:\n",
          "Result:\n", "$ipv4Table\n",
          "Expected:\n", "$targetIPv4Table\n"
        );
        "$ipv6Table" eq "$targetIPv6Table" or die(
          "The IPv6 routing table does not match the expected one:\n",
          "Result:\n", "$ipv6Table\n",
          "Expected:\n", "$targetIPv6Table\n"
        );

        # test clean-up of the tables
        $machine->succeed("systemctl stop network-addresses-eth0");
        my $ipv4Residue = $machine->succeed("ip -4 route list dev eth0 | head -n-3");
        my $ipv6Residue = $machine->succeed("ip -6 route list dev eth0 | head -n-3");
        $ipv4Residue eq "" or die(
          "The IPv4 routing table has not been properly cleaned:\n",
          "$ipv4Residue\n"
        );
        $ipv6Residue eq "" or die(
          "The IPv6 routing table has not been properly cleaned:\n",
          "$ipv6Residue\n"
        );
      '';
    };
  };

in mapAttrs (const (attrs: makeTest (attrs // {
  name = "${attrs.name}-Networking-${if networkd then "Networkd" else "Scripted"}";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ wkennington ];
  };
}))) testCases
