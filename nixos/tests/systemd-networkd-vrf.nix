import ./make-test-python.nix ({ pkgs, lib, ... }: let
  inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
in {
  name = "systemd-networkd-vrf";
  meta.maintainers = with lib.maintainers; [ ma27 ];

  nodes = {
    client = { pkgs, ... }: {
      virtualisation.vlans = [ 1 2 ];

      networking = {
        useDHCP = false;
        useNetworkd = true;
        firewall.checkReversePath = "loose";
      };

      systemd.network = {
        enable = true;

        netdevs."10-vrf1" = {
          netdevConfig = {
            Kind = "vrf";
            Name = "vrf1";
            MTUBytes = "1300";
          };
          vrfConfig.Table = 23;
        };
        netdevs."10-vrf2" = {
          netdevConfig = {
            Kind = "vrf";
            Name = "vrf2";
            MTUBytes = "1300";
          };
          vrfConfig.Table = 42;
        };

        networks."10-vrf1" = {
          matchConfig.Name = "vrf1";
          networkConfig.IPForward = "yes";
          routes = [
            { routeConfig = { Destination = "192.168.1.2"; Metric = "100"; }; }
          ];
        };
        networks."10-vrf2" = {
          matchConfig.Name = "vrf2";
          networkConfig.IPForward = "yes";
          routes = [
            { routeConfig = { Destination = "192.168.2.3"; Metric = "100"; }; }
          ];
        };

        networks."10-eth1" = {
          matchConfig.Name = "eth1";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            VRF = "vrf1";
            Address = "192.168.1.1";
            IPForward = "yes";
          };
        };
        networks."10-eth2" = {
          matchConfig.Name = "eth2";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            VRF = "vrf2";
            Address = "192.168.2.1";
            IPForward = "yes";
          };
        };
      };
    };

    node1 = { pkgs, ... }: {
      virtualisation.vlans = [ 1 ];
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      services.openssh.enable = true;
      users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];

      systemd.network = {
        enable = true;

        networks."10-eth1" = {
          matchConfig.Name = "eth1";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            Address = "192.168.1.2";
            IPForward = "yes";
          };
        };
      };
    };

    node2 = { pkgs, ... }: {
      virtualisation.vlans = [ 2 ];
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.network = {
        enable = true;

        networks."10-eth2" = {
          matchConfig.Name = "eth2";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            Address = "192.168.2.3";
            IPForward = "yes";
          };
        };
      };
    };

    node3 = { pkgs, ... }: {
      virtualisation.vlans = [ 2 ];
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.network = {
        enable = true;

        networks."10-eth2" = {
          matchConfig.Name = "eth2";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            Address = "192.168.2.4";
            IPForward = "yes";
          };
        };
      };
    };
  };

  testScript = ''
    def compare_tables(expected, actual):
        assert (
            expected == actual
        ), """
        Routing tables don't match!
        Expected:
          {}
        Actual:
          {}
        """.format(
            expected, actual
        )


    start_all()

    client.wait_for_unit("network.target")
    node1.wait_for_unit("network.target")
    node2.wait_for_unit("network.target")
    node3.wait_for_unit("network.target")

    client_ipv4_table = """
    192.168.1.2 dev vrf1 proto static metric 100 
    192.168.2.3 dev vrf2 proto static metric 100
    """.strip()
    vrf1_table = """
    broadcast 192.168.1.0 dev eth1 proto kernel scope link src 192.168.1.1 
    192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.1 
    local 192.168.1.1 dev eth1 proto kernel scope host src 192.168.1.1 
    broadcast 192.168.1.255 dev eth1 proto kernel scope link src 192.168.1.1
    """.strip()
    vrf2_table = """
    broadcast 192.168.2.0 dev eth2 proto kernel scope link src 192.168.2.1 
    192.168.2.0/24 dev eth2 proto kernel scope link src 192.168.2.1 
    local 192.168.2.1 dev eth2 proto kernel scope host src 192.168.2.1 
    broadcast 192.168.2.255 dev eth2 proto kernel scope link src 192.168.2.1
    """.strip()

    # Check that networkd properly configures the main routing table
    # and the routing tables for the VRF.
    with subtest("check vrf routing tables"):
        compare_tables(
            client_ipv4_table, client.succeed("ip -4 route list | head -n2").strip()
        )
        compare_tables(
            vrf1_table, client.succeed("ip -4 route list table 23 | head -n4").strip()
        )
        compare_tables(
            vrf2_table, client.succeed("ip -4 route list table 42 | head -n4").strip()
        )

    # Ensure that other nodes are reachable via ICMP through the VRF.
    with subtest("icmp through vrf works"):
        client.succeed("ping -c5 192.168.1.2")
        client.succeed("ping -c5 192.168.2.3")

    # Test whether SSH through a VRF IP is possible.
    # (Note: this seems to be an issue on Linux 5.x, so I decided to add this to
    # ensure that we catch this when updating the default kernel).
    # with subtest("tcp traffic through vrf works"):
    #     node1.wait_for_open_port(22)
    #     client.succeed(
    #         "cat ${snakeOilPrivateKey} > privkey.snakeoil"
    #     )
    #     client.succeed("chmod 600 privkey.snakeoil")
    #     client.succeed(
    #         "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil root@192.168.1.2 true"
    #     )

    # Only configured routes through the VRF from the main routing table should
    # work. Additional IPs are only reachable when binding to the vrf interface.
    with subtest("only routes from main routing table work by default"):
        client.fail("ping -c5 192.168.2.4")
        client.succeed("ping -I vrf2 -c5 192.168.2.4")

    client.shutdown()
    node1.shutdown()
    node2.shutdown()
    node3.shutdown()
  '';
})
