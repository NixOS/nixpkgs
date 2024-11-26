/*
  This test ensures that we can configure spanning-tree protocol
  across bridges using systemd-networkd.

  Test topology:

             1       2       3
      node1 --- sw1 --- sw2 --- node2
                  \     /
                 4 \   / 5
                    sw3
                     |
                   6 |
                     |
                   node3

  where switches 1, 2, and 3 bridge their links and use STP,
  and each link is labeled with the VLAN we are assigning it in
  virtualisation.vlans.
*/
with builtins;
let
  commonConf = {
    systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
    networking.useNetworkd = true;
    networking.useDHCP = false;
    networking.firewall.enable = false;
  };

  generateNodeConf =
    { octet, vlan }:
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        common/user-account.nix
        commonConf
      ];
      virtualisation.vlans = [ vlan ];
      systemd.network = {
        enable = true;
        networks = {
          "30-eth" = {
            matchConfig.Name = "eth1";
            address = [ "10.0.0.${toString octet}/24" ];
          };
        };
      };
    };

  generateSwitchConf =
    vlans:
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        common/user-account.nix
        commonConf
      ];
      virtualisation.vlans = vlans;
      systemd.network = {
        enable = true;
        netdevs = {
          "40-br0" = {
            netdevConfig = {
              Kind = "bridge";
              Name = "br0";
            };
            bridgeConfig.STP = "yes";
          };
        };
        networks = {
          "30-eth" = {
            matchConfig.Name = "eth*";
            networkConfig.Bridge = "br0";
          };
          "40-br0" = {
            matchConfig.Name = "br0";
          };
        };
      };
    };
in
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "networkd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ picnoir ];
    };
    nodes = {
      node1 = generateNodeConf {
        octet = 1;
        vlan = 1;
      };
      node2 = generateNodeConf {
        octet = 2;
        vlan = 3;
      };
      node3 = generateNodeConf {
        octet = 3;
        vlan = 6;
      };
      sw1 = generateSwitchConf [
        1
        2
        4
      ];
      sw2 = generateSwitchConf [
        2
        3
        5
      ];
      sw3 = generateSwitchConf [
        4
        5
        6
      ];
    };
    testScript = ''
      network_nodes = [node1, node2, node3]
      network_switches = [sw1, sw2, sw3]
      start_all()

      for n in network_nodes + network_switches:
          n.wait_for_unit("systemd-networkd-wait-online.service")

      node1.succeed("ping 10.0.0.2 -w 10 -c 1")
      node1.succeed("ping 10.0.0.3 -w 10 -c 1")
      node2.succeed("ping 10.0.0.1 -w 10 -c 1")
      node2.succeed("ping 10.0.0.3 -w 10 -c 1")
      node3.succeed("ping 10.0.0.1 -w 10 -c 1")
      node3.succeed("ping 10.0.0.2 -w 10 -c 1")
    '';
  }
)
