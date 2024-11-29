{ pkgs, runTest }:

let
  inherit (pkgs) lib;

  ipv6Only = {
    networking.useDHCP = false;
    networking.interfaces.eth1.ipv4.addresses = lib.mkVMOverride [ ];
  };

  ipv4Only = {
    networking.useDHCP = false;
    networking.interfaces.eth1.ipv6.addresses = lib.mkVMOverride [ ];
  };

  webserver = ip: msg: {
    systemd.services.webserver = {
      description = "Mock webserver";
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        while true; do
        {
          printf 'HTTP/1.0 200 OK\n'
          printf 'Content-Length: ${toString (1 + builtins.stringLength msg)}\n'
          printf '\n${msg}\n\n'
        } | ${pkgs.libressl.nc}/bin/nc -${toString ip}nvl 80
        done
      '';
    };
    networking.firewall.allowedTCPPorts = [ 80 ];
  };

in

{
  siit = runTest {
    # This test simulates the setup described in [1] with two IPv6 and
    # IPv4-only devices on different subnets communicating through a border
    # relay running Jool in SIIT mode.
    # [1]: https://nicmx.github.io/Jool/en/run-vanilla.html
    name = "jool-siit";
    meta.maintainers = with lib.maintainers; [ rnhmjoj ];

    # Border relay
    nodes.relay = {
      virtualisation.vlans = [ 1 2 ];

      # Enable packet routing
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
      };

      networking.useDHCP = false;
      networking.interfaces = lib.mkVMOverride {
        eth1.ipv6.addresses = [ { address = "fd::198.51.100.1"; prefixLength = 120; } ];
        eth2.ipv4.addresses = [ { address = "192.0.2.1";  prefixLength = 24; } ];
      };

      networking.jool.enable = true;
      networking.jool.siit.default.global.pool6 = "fd::/96";
    };

    # IPv6 only node
    nodes.alice = {
      imports = [ ipv6Only (webserver 6 "Hello, Bob!") ];

      virtualisation.vlans = [ 1 ];
      networking.interfaces.eth1.ipv6 = {
        addresses = [ { address = "fd::198.51.100.8"; prefixLength = 120; } ];
        routes    = [ { address = "fd::192.0.2.0"; prefixLength = 120;
                        via = "fd::198.51.100.1"; } ];
      };
    };

    # IPv4 only node
    nodes.bob = {
      imports = [ ipv4Only (webserver 4 "Hello, Alice!") ];

      virtualisation.vlans = [ 2 ];
      networking.interfaces.eth1.ipv4 = {
        addresses = [ { address = "192.0.2.16"; prefixLength = 24; } ];
        routes    = [ { address = "198.51.100.0"; prefixLength = 24;
                        via = "192.0.2.1"; } ];
      };
    };

    testScript = ''
      start_all()

      relay.wait_for_unit("jool-siit-default.service")
      alice.wait_for_unit("network-addresses-eth1.service")
      bob.wait_for_unit("network-addresses-eth1.service")

      with subtest("Alice and Bob can't ping each other"):
        relay.systemctl("stop jool-siit-default.service")
        alice.fail("ping -c1 fd::192.0.2.16")
        bob.fail("ping -c1 198.51.100.8")

      with subtest("Alice and Bob can ping using the relay"):
        relay.systemctl("start jool-siit-default.service")
        alice.wait_until_succeeds("ping -c1 fd::192.0.2.16")
        bob.wait_until_succeeds("ping -c1 198.51.100.8")

      with subtest("Alice can connect to Bob's webserver"):
        bob.wait_for_open_port(80)
        alice.succeed("curl -vvv http://[fd::192.0.2.16] >&2")
        alice.succeed("curl --fail -s http://[fd::192.0.2.16] | grep -q Alice")

      with subtest("Bob can connect to Alices's webserver"):
        alice.wait_for_open_port(80)
        bob.succeed("curl --fail -s http://198.51.100.8 | grep -q Bob")
    '';
  };

  nat64 = runTest {
    # This test simulates the setup described in [1] with two IPv6-only nodes
    # (a client and a homeserver) on the LAN subnet and an IPv4 node on the WAN.
    # The router runs Jool in stateful NAT64 mode, masquarading the LAN and
    # forwarding ports using static BIB entries.
    # [1]: https://nicmx.github.io/Jool/en/run-nat64.html
    name = "jool-nat64";
    meta.maintainers = with lib.maintainers; [ rnhmjoj ];

    # Router
    nodes.router = {
      virtualisation.vlans = [ 1 2 ];

      # Enable packet routing
      boot.kernel.sysctl = {
        "net.ipv6.conf.all.forwarding" = 1;
        "net.ipv4.conf.all.forwarding" = 1;
      };

      networking.useDHCP = false;
      networking.interfaces = lib.mkVMOverride {
        eth1.ipv6.addresses = [ { address = "2001:db8::1"; prefixLength = 96; } ];
        eth2.ipv4.addresses = [ { address = "203.0.113.1"; prefixLength = 24; } ];
      };

      networking.jool.enable = true;
      networking.jool.nat64.default = {
        bib = [
          { # forward HTTP 203.0.113.1 (router) → 2001:db8::9 (homeserver)
            "protocol"     = "TCP";
            "ipv4 address" = "203.0.113.1#80";
            "ipv6 address" = "2001:db8::9#80";
          }
        ];
        pool4 = [
          # Ports for dynamic translation
          { protocol =  "TCP";  prefix = "203.0.113.1/32"; "port range" = "40001-65535"; }
          { protocol =  "UDP";  prefix = "203.0.113.1/32"; "port range" = "40001-65535"; }
          { protocol = "ICMP";  prefix = "203.0.113.1/32"; "port range" = "40001-65535"; }
          # Ports for static BIB entries
          { protocol =  "TCP";  prefix = "203.0.113.1/32"; "port range" = "80"; }
        ];
      };
    };

    # LAN client (IPv6 only)
    nodes.client = {
      imports = [ ipv6Only ];
      virtualisation.vlans = [ 1 ];

      networking.interfaces.eth1.ipv6 = {
        addresses = lib.mkForce [ { address = "2001:db8::8"; prefixLength = 96; } ];
        routes = lib.mkForce [ {
          address = "64:ff9b::";
          prefixLength = 96;
          via = "2001:db8::1";
        } ];
      };
    };

    # LAN server (IPv6 only)
    nodes.homeserver = {
      imports = [ ipv6Only (webserver 6 "Hello from IPv6!") ];

      virtualisation.vlans = [ 1 ];
      networking.interfaces.eth1.ipv6 = {
        addresses = lib.mkForce [ { address = "2001:db8::9"; prefixLength = 96; } ];
        routes    = lib.mkForce [ {
          address = "64:ff9b::";
          prefixLength = 96;
          via = "2001:db8::1";
        } ];
      };
    };

    # WAN server (IPv4 only)
    nodes.server = {
      imports = [ ipv4Only (webserver 4 "Hello from IPv4!") ];

      virtualisation.vlans = [ 2 ];
      networking.interfaces.eth1.ipv4.addresses =
        [ { address = "203.0.113.16"; prefixLength = 24; } ];
    };

    testScript = ''
      start_all()

      for node in [client, homeserver, server]:
        node.wait_for_unit("network-addresses-eth1.service")

      with subtest("Client can ping the WAN server"):
        router.wait_for_unit("jool-nat64-default.service")
        client.succeed("ping -c1 64:ff9b::203.0.113.16")

      with subtest("Client can connect to the WAN webserver"):
        server.wait_for_open_port(80)
        client.succeed("curl --fail -s http://[64:ff9b::203.0.113.16] | grep -q IPv4!")

      with subtest("Router BIB entries are correctly populated"):
        router.succeed("jool bib display | grep -q 'Dynamic TCP.*2001:db8::8'")
        router.succeed("jool bib display | grep -q 'Static TCP.*2001:db8::9'")

      with subtest("WAN server can reach the LAN server"):
        homeserver.wait_for_open_port(80)
        server.succeed("curl --fail -s http://203.0.113.1 | grep -q IPv6!")
    '';

  };

}
