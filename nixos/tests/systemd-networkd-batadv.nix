{ lib, ... }:
{
  name = "systemd-networkd-batadv";

  meta = with lib.maintainers; {
    maintainers = [ herbetom ];
  };

  nodes = {
    machineA =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];
        systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.enable = false;
        };

        # Use default batman_adv module from kernel
        boot.extraModulePackages = [ ];

        environment.systemPackages = [
          pkgs.batctl
          pkgs.jq
        ];

        systemd.network = {
          networks."10-eth1" = {
            matchConfig.Name = "eth1";
            networkConfig = {
              BatmanAdvanced = config.systemd.network.netdevs."20-bat0".netdevConfig.Name;
              IPv6AcceptRA = false;
            };
          };
          netdevs."20-bat0" = {
            netdevConfig = {
              Name = "bat0";
              Kind = "batadv";
              MACAddress = "00:00:5e:00:53:00";
            };
            batmanAdvancedConfig = {
              OriginatorIntervalSec = "5";
              RoutingAlgorithm = "batman-iv";
            };
          };
          networks."20-bat0" = {
            matchConfig.Name = config.systemd.network.netdevs."20-bat0".netdevConfig.Name;
            networkConfig.IPv6AcceptRA = false;
            address = [
              "10.0.0.1/24"
              "2001:db8::a/64"
            ];

          };
        };
      };
    machineB =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];
        systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";

        networking = {
          useNetworkd = true;
          useDHCP = false;
          firewall.enable = false;
        };

        # Use batman_adv module from nixpkgs
        boot.extraModulePackages = [ config.boot.kernelPackages.batman_adv ];

        environment.systemPackages = [
          pkgs.batctl
          pkgs.jq
        ];

        systemd.network = {
          networks."10-eth1" = {
            matchConfig.Name = "eth1";
            networkConfig = {
              BatmanAdvanced = config.systemd.network.netdevs."20-bat0".netdevConfig.Name;
              IPv6AcceptRA = false;
            };
          };
          netdevs."20-bat0" = {
            netdevConfig = {
              Name = "bat0";
              Kind = "batadv";
              MACAddress = "00:00:5e:00:53:10";
            };
            batmanAdvancedConfig = {
              OriginatorIntervalSec = "5";
              RoutingAlgorithm = "batman-iv";
            };
          };
          networks."20-bat0" = {
            matchConfig.Name = config.systemd.network.netdevs."20-bat0".netdevConfig.Name;
            networkConfig.IPv6AcceptRA = false;
            address = [
              "10.0.0.2/24"
              "2001:db8::b/64"
            ];

          };
        };
      };
  };

  testScript = ''
    start_all()

    machineA.wait_for_unit("default.target")
    machineB.wait_for_unit("default.target")

    print(machineA.succeed("batctl -v").strip())
    print(machineB.succeed("batctl -v").strip())

    machineA.wait_until_succeeds('batctl neighbors_json | jq -e ".[0].neigh_address | select(length > 0)"')

    print(machineA.succeed("batctl n").strip())
    print(machineB.succeed("batctl n").strip())

    print(machineA.wait_until_succeeds("batctl ping -c 5 00:00:5e:00:53:10").strip())
    print(machineB.wait_until_succeeds("batctl ping -c 5 00:00:5e:00:53:00").strip())

    print(machineA.wait_until_succeeds("ping -c 5 2001:db8::b"))
    print(machineB.wait_until_succeeds("ping -c 5 10.0.0.1"))

    machineA.fail("ping -c 3 10.0.0.99")
  '';
}
