import ./make-test-python.nix ({ pkgs, lib, ... }: let
  inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

  mkNode = vlan: id: {
    virtualisation.vlans = [ vlan ];
    networking = {
      useDHCP = false;
      useNetworkd = true;
    };

    systemd.network = {
      enable = true;

      networks."10-eth${toString vlan}" = {
        matchConfig.Name = "eth${toString vlan}";
        linkConfig.RequiredForOnline = "no";
        networkConfig = {
          Address = "192.168.${toString vlan}.${toString id}/24";
          IPForward = "yes";
        };
      };
    };
  };
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
            { Destination = "192.168.1.2"; Metric = 100; }
          ];
        };
        networks."10-vrf2" = {
          matchConfig.Name = "vrf2";
          networkConfig.IPForward = "yes";
          routes = [
            { Destination = "192.168.2.3"; Metric = 100; }
          ];
        };

        networks."10-eth1" = {
          matchConfig.Name = "eth1";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            VRF = "vrf1";
            Address = "192.168.1.1/24";
            IPForward = "yes";
          };
        };
        networks."10-eth2" = {
          matchConfig.Name = "eth2";
          linkConfig.RequiredForOnline = "no";
          networkConfig = {
            VRF = "vrf2";
            Address = "192.168.2.1/24";
            IPForward = "yes";
          };
        };
      };
    };

    node1 = lib.mkMerge [
      (mkNode 1 2)
      {
        services.openssh.enable = true;
        users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
      }
    ];

    node2 = mkNode 2 3;
    node3 = mkNode 2 4;
  };

  testScript = ''
    import json

    def compare(raw_json, to_compare):
        data = json.loads(raw_json)
        assert len(raw_json) >= len(to_compare)
        for i, row in enumerate(to_compare):
            actual = data[i]
            assert len(row.keys()) > 0
            for key, value in row.items():
                assert value == actual[key], f"""
                  In entry {i}, value {key}: got: {actual[key]}, expected {value}
                """


    start_all()

    client.wait_for_unit("network.target")
    node1.wait_for_unit("network.target")
    node2.wait_for_unit("network.target")
    node3.wait_for_unit("network.target")

    # Check that networkd properly configures the main routing table
    # and the routing tables for the VRF.
    with subtest("check vrf routing tables"):
        compare(
            client.succeed("ip --json -4 route list"),
            [
                {"dst": "192.168.1.2", "dev": "vrf1", "metric": 100},
                {"dst": "192.168.2.3", "dev": "vrf2", "metric": 100}
            ]
        )
        compare(
            client.succeed("ip --json -4 route list table 23"),
            [
                {"dst": "192.168.1.0/24", "dev": "eth1", "prefsrc": "192.168.1.1"},
                {"type": "local", "dst": "192.168.1.1", "dev": "eth1", "prefsrc": "192.168.1.1"},
                {"type": "broadcast", "dev": "eth1", "prefsrc": "192.168.1.1", "dst": "192.168.1.255"}
            ]
        )
        compare(
            client.succeed("ip --json -4 route list table 42"),
            [
                {"dst": "192.168.2.0/24", "dev": "eth2", "prefsrc": "192.168.2.1"},
                {"type": "local", "dst": "192.168.2.1", "dev": "eth2", "prefsrc": "192.168.2.1"},
                {"type": "broadcast", "dev": "eth2", "prefsrc": "192.168.2.1", "dst": "192.168.2.255"}
            ]
        )

    # Ensure that other nodes are reachable via ICMP through the VRF.
    with subtest("icmp through vrf works"):
        client.succeed("ping -c5 192.168.1.2")
        client.succeed("ping -c5 192.168.2.3")

    # Test whether TCP through a VRF IP is possible.
    with subtest("tcp traffic through vrf works"):
        node1.wait_for_open_port(22)
        client.succeed(
            "cat ${snakeOilPrivateKey} > privkey.snakeoil"
        )
        client.succeed("chmod 600 privkey.snakeoil")
        client.succeed(
            "ulimit -l 2048; ip vrf exec vrf1 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i privkey.snakeoil root@192.168.1.2 true"
        )

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
