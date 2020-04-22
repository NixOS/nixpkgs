# This test predominantly tests systemd-networkd DHCP server, by
# setting up a DHCP server and client, and ensuring they are mutually
# reachable via the DHCP allocated address.
import ./make-test-python.nix ({pkgs, ...}: {
  name = "systemd-networkd-dhcpserver";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ tomfitzhenry ];
  };
  nodes = {
    router = { config, pkgs, ... }: {
      virtualisation.vlans = [ 1 ];
      systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.enable = false;
      };
      systemd.network = {
        networks = {
          # systemd-networkd will load the first network unit file
          # that matches, ordered lexiographically by filename.
          # /etc/systemd/network/{40-eth1,99-main}.network already
          # exists. This network unit must be loaded for the test,
          # however, hence why this network is named such.
          "01-eth1" = {
            name = "eth1";
            networkConfig = {
              DHCPServer = true;
              Address = "10.0.0.1/24";
            };
            dhcpServerConfig = {
              PoolOffset = 100;
              PoolSize = 1;
            };
          };
        };
      };
    };

    client = { config, pkgs, ... }: {
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
  testScript = { ... }: ''
    start_all()
    router.wait_for_unit("systemd-networkd-wait-online.service")
    client.wait_for_unit("systemd-networkd-wait-online.service")
    client.wait_until_succeeds("ping -c 5 10.0.0.1")
    router.wait_until_succeeds("ping -c 5 10.0.0.100")
  '';
})
