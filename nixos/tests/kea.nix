import ./make-test-python.nix ({ pkgs, lib, ...}: {
  meta.maintainers = with lib.maintainers; [ hexa ];

  name = "kea";

  nodes = {
    router = { config, pkgs, ... }: {
      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.allowedUDPPorts = [ 67 ];
      };

      systemd.network = {
        networks = {
          "01-eth1" = {
            name = "eth1";
            networkConfig = {
              Address = "10.0.0.1/30";
            };
          };
        };
      };

      services.kea.dhcp4 = {
        enable = true;
        settings = {
          valid-lifetime = 3600;
          renew-timer = 900;
          rebind-timer = 1800;

          lease-database = {
            type = "memfile";
            persist = true;
            name = "/var/lib/kea/dhcp4.leases";
          };

          interfaces-config = {
            dhcp-socket-type = "raw";
            interfaces = [
              "eth1"
            ];
          };

          subnet4 = [ {
            subnet = "10.0.0.0/30";
            pools = [ {
              pool = "10.0.0.2 - 10.0.0.2";
            } ];
          } ];
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
    router.wait_for_unit("kea-dhcp4-server.service")
    client.wait_for_unit("systemd-networkd-wait-online.service")
    client.wait_until_succeeds("ping -c 5 10.0.0.1")
    router.wait_until_succeeds("ping -c 5 10.0.0.2")
  '';
})
