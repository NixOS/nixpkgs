# This test predominantly tests systemd-networkd DHCP server, by
# setting up a DHCP server and client, and ensuring they are mutually
# reachable via the DHCP allocated address.
# Two DHCP servers are set up on bridge VLANs, testing to make sure that
# bridge VLAN settings are correctly applied.
#
# br0 ----untagged---v
#                    +---PVID 1+VLAN 2---[bridge]---PVID 2---eth1
# vlan2 ---VLAN 2----^
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "systemd-networkd-dhcpserver";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ];
    };
    nodes = {
      router =
        { config, pkgs, ... }:
        {
          virtualisation.vlans = [ 1 ];
          systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
          };
          systemd.network = {
            netdevs = {
              br0 = {
                enable = true;
                netdevConfig = {
                  Name = "br0";
                  Kind = "bridge";
                };
                extraConfig = ''
                  [Bridge]
                  VLANFiltering=yes
                  DefaultPVID=none
                '';
              };
              vlan2 = {
                enable = true;
                netdevConfig = {
                  Name = "vlan2";
                  Kind = "vlan";
                };
                vlanConfig.Id = 2;
              };
            };
            networks = {
              # systemd-networkd will load the first network unit file
              # that matches, ordered lexiographically by filename.
              # /etc/systemd/network/{40-eth1,99-main}.network already
              # exists. This network unit must be loaded for the test,
              # however, hence why this network is named such.
              "01-eth1" = {
                name = "eth1";
                networkConfig.Bridge = "br0";
                bridgeVLANs = [
                  {
                    bridgeVLANConfig = {
                      PVID = 2;
                      EgressUntagged = 2;
                    };
                  }
                ];
              };
              "02-br0" = {
                name = "br0";
                networkConfig = {
                  DHCPServer = true;
                  Address = "10.0.0.1/24";
                  VLAN = [ "vlan2" ];
                };
                dhcpServerConfig = {
                  PoolOffset = 100;
                  PoolSize = 1;
                };
                bridgeVLANs = [
                  {
                    bridgeVLANConfig = {
                      PVID = 1;
                      EgressUntagged = 1;
                    };
                  }
                  {
                    bridgeVLANConfig = {
                      VLAN = 2;
                    };
                  }
                ];
              };
              "02-vlan2" = {
                name = "vlan2";
                networkConfig = {
                  DHCPServer = true;
                  Address = "10.0.2.1/24";
                };
                dhcpServerConfig = {
                  PoolOffset = 100;
                  PoolSize = 1;
                };
              };
            };
          };
        };

      client =
        { config, pkgs, ... }:
        {
          virtualisation.vlans = [ 1 ];
          systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
          networking = {
            useNetworkd = true;
            useDHCP = false;
            firewall.enable = false;
            interfaces.eth1.useDHCP = true;
          };
        };
    };
    testScript =
      { ... }:
      ''
        start_all()

        router.systemctl("start network-online.target")
        client.systemctl("start network-online.target")
        router.wait_for_unit("systemd-networkd-wait-online.service")
        client.wait_for_unit("systemd-networkd-wait-online.service")
        client.wait_until_succeeds("ping -c 5 10.0.2.1")
        router.wait_until_succeeds("ping -c 5 10.0.2.100")
      '';
  }
)
