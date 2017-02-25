{ system ? builtins.currentSystem, networkd }:

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
            ipAddress = "192.168.${toString n}.1";
            prefixLength = 24;
            ipv6Address = "fd00:1234:5678:${toString n}::1";
            ipv6PrefixLength = 64;
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
      nodes.client = { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          defaultGateway = "192.168.1.1";
          interfaces.eth1.ip4 = mkOverride 0 [
            { address = "192.168.1.2"; prefixLength = 24; }
            { address = "192.168.1.3"; prefixLength = 32; }
            { address = "192.168.1.10"; prefixLength = 32; }
          ];
          interfaces.eth2.ip4 = mkOverride 0 [
            { address = "192.168.2.2"; prefixLength = 24; }
          ];
        };
      };
      testScript = { nodes, ... }:
        ''
          startAll;

          $client->waitForUnit("network.target");
          $router->waitForUnit("network.target");

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
      nodes.client = { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = true;
          interfaces.eth1 = {
            ip4 = mkOverride 0 [ ];
            ip6 = mkOverride 0 [ ];
          };
          interfaces.eth2 = {
            ip4 = mkOverride 0 [ ];
            ip6 = mkOverride 0 [ ];
          };
        };
      };
      testScript = { nodes, ... }:
        ''
          startAll;

          $client->waitForUnit("network.target");
          $router->waitForUnit("network.target");

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
      nodes.client = { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          interfaces.eth1 = {
            ip4 = mkOverride 0 [ ];
            useDHCP = true;
          };
          interfaces.eth2.ip4 = mkOverride 0 [ ];
        };
      };
      testScript = { nodes, ... }:
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
      node = address: { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          bonds.bond = {
            interfaces = [ "eth1" "eth2" ];
            driverOptions.mode = "balance-rr";
          };
          interfaces.eth1.ip4 = mkOverride 0 [ ];
          interfaces.eth2.ip4 = mkOverride 0 [ ];
          interfaces.bond.ip4 = mkOverride 0
            [ { inherit address; prefixLength = 30; } ];
        };
      };
    in {
      name = "Bond";
      nodes.client1 = node "192.168.1.1";
      nodes.client2 = node "192.168.1.2";
      testScript = { nodes, ... }:
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
      node = { address, vlan }: { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ vlan ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          interfaces.eth1.ip4 = mkOverride 0
            [ { inherit address; prefixLength = 24; } ];
        };
      };
    in {
      name = "Bridge";
      nodes.client1 = node { address = "192.168.1.2"; vlan = 1; };
      nodes.client2 = node { address = "192.168.1.3"; vlan = 2; };
      nodes.router = { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 2 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          bridges.bridge.interfaces = [ "eth1" "eth2" ];
          interfaces.eth1.ip4 = mkOverride 0 [ ];
          interfaces.eth2.ip4 = mkOverride 0 [ ];
          interfaces.bridge.ip4 = mkOverride 0
            [ { address = "192.168.1.1"; prefixLength = 24; } ];
        };
      };
      testScript = { nodes, ... }:
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
      nodes.client = { config, pkgs, ... }: with pkgs.lib; {
        virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = true;
          macvlans.macvlan.interface = "eth1";
          interfaces.eth1.ip4 = mkOverride 0 [ ];
        };
      };
      testScript = { nodes, ... }:
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
      node = { address4, remote, address6 }: { config, pkgs, ... }: with pkgs.lib; {
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
          interfaces.eth1.ip4 = mkOverride 0
            [ { address = address4; prefixLength = 24; } ];
          interfaces.sit.ip6 = mkOverride 0
            [ { address = address6; prefixLength = 64; } ];
        };
      };
    in {
      name = "Sit";
      nodes.client1 = node { address4 = "192.168.1.1"; remote = "192.168.1.2"; address6 = "fc00::1"; };
      nodes.client2 = node { address4 = "192.168.1.2"; remote = "192.168.1.1"; address6 = "fc00::2"; };
      testScript = { nodes, ... }:
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
      node = address: { config, pkgs, ... }: with pkgs.lib; {
        #virtualisation.vlans = [ 1 ];
        networking = {
          useNetworkd = networkd;
          firewall.allowPing = true;
          useDHCP = false;
          vlans.vlan = {
            id = 1;
            interface = "eth0";
          };
          interfaces.eth0.ip4 = mkOverride 0 [ ];
          interfaces.eth1.ip4 = mkOverride 0 [ ];
          interfaces.vlan.ip4 = mkOverride 0
            [ { inherit address; prefixLength = 24; } ];
        };
      };
    in {
      name = "vlan";
      nodes.client1 = node "192.168.1.1";
      nodes.client2 = node "192.168.1.2";
      testScript = { nodes, ... }:
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
  };

in mapAttrs (const (attrs: makeTest (attrs // {
  name = "${attrs.name}-Networking-${if networkd then "Networkd" else "Scripted"}";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ wkennington ];
  };
}))) testCases
