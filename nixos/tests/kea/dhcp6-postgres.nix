# This test verifies DHCPv6 interaction between a client and a router.
# The DHCPv6 server uses a PostgreSQL database, where a reservation is
# made through the control socket.
# We then verify whether client and router can ping each other.

{
  pkgs,
  lib,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ wfdewith ];

  name = "dhcp6-postgres";

  containers = {
    router =
      { config, pkgs, ... }:
      {
        virtualisation.interfaces.eth1 = {
          vlan = 1;
          assignIP = false;
        };

        networking = {
          useDHCP = false;
          firewall.enable = false;
        };

        services.resolved.enable = false;
        systemd.network = {
          enable = true;
          networks = {
            "01-eth1" = {
              name = "eth1";
              networkConfig = {
                Address = "fc00:c0de::1/64";
                IPv6SendRA = true;
              };
              ipv6Prefixes = [
                {
                  Prefix = "fc00:c0de::/64";
                  AddressAutoconfiguration = false;
                }
              ];
              ipv6SendRAConfig.Managed = true;
            };
          };
        };

        services.postgresql = {
          enable = true;
          settings = {
            password_encryption = "md5";
          };
          initialScript = pkgs.writeText "init-kea-db" ''
            CREATE ROLE kea WITH LOGIN PASSWORD 'kea';
            CREATE DATABASE kea OWNER kea;
          '';
        };

        services.kea.dhcp6 = {
          enable = true;
          extraArgs = [ "-X" ];
          settings = {
            valid-lifetime = 3600;
            renew-timer = 900;
            rebind-timer = 1800;

            hooks-libraries = [
              { library = "libdhcp_pgsql.so"; }
              { library = "libdhcp_host_cmds.so"; }
            ];

            lease-database = {
              type = "postgresql";
              name = "kea";
              user = "kea";
              password = "kea";
              host = "localhost";
            };

            hosts-databases = [
              {
                type = "postgresql";
                name = "kea";
                user = "kea";
                password = "kea";
                host = "localhost";
              }
            ];

            control-sockets = [
              {
                socket-type = "unix";
                socket-name = "/run/kea/dhcp6.sock";
              }
              {
                socket-type = "http";
                socket-address = "127.0.0.1";
                socket-port = 8000;
              }
            ];

            interfaces-config = {
              interfaces = [
                "eth1"
              ];
            };

            subnet6 = [
              {
                id = 1;
                subnet = "fc00:c0de::/64";
                interface = "eth1";
                pools = [
                  {
                    pool = "fc00:c0de::dead - fc00:c0de::dead";
                  }
                ];
              }
            ];
          };
        };

        services.prometheus.exporters.kea = {
          enable = true;
          targets = [
            "/run/kea/dhcp6.sock"
          ];
        };

        environment.systemPackages = with pkgs; [ jq ];
      };

    client =
      { config, pkgs, ... }:
      {
        virtualisation.interfaces.eth1 = {
          vlan = 1;
          assignIP = false;
        };

        services.resolved.enable = false;
        systemd.services.systemd-networkd.environment.SYSTEMD_LOG_LEVEL = "debug";
        networking = {
          useDHCP = false;
          firewall.enable = false;
        };

        systemd.network = {
          enable = true;
          networks = {
            "01-eth1" = {
              name = "eth1";
              networkConfig = {
                DHCP = true;
              };
              dhcpV6Config = {
                DUIDType = "uuid";
                DUIDRawData = "30:0e:49:fb:08:9f:44:d1:9d:47:a7:9c:9e:56:68:9a";
              };
            };
          };
        };
      };
  };
  testScript =
    # python
    ''
      import shlex

      router.start()
      router.systemctl("stop kea-dhcp6-server.service")
      router.systemctl("stop prometheus-kea-exporter.service")

      with subtest("PostgreSQL initialization"):
        router.wait_for_unit("postgresql-setup.service")
        router.succeed("kea-admin db-init pgsql -u kea -p kea -n kea")

      with subtest("DHCPv6 reservation"):
        router.systemctl("start kea-dhcp6-server.service")
        router.wait_until_succeeds("kea-shell version-get")

        reservation = r"""
        "reservation": {
          "subnet-id": 1,
          "duid": "00:04:30:0e:49:fb:08:9f:44:d1:9d:47:a7:9c:9e:56:68:9a",
          "ip-addresses": ["fc00:c0de::cafe"]
        }
        """
        router.succeed(f"kea-shell reservation-add <<< {shlex.quote(reservation)} | jq -e 'all(.[], .result == 0)'")

      with subtest("DHCPv6"):
        client.start()
        client.systemctl("start systemd-networkd-wait-online.service")
        client.wait_for_unit("systemd-networkd-wait-online.service")
        client.wait_until_succeeds("ping -c 5 fc00:c0de::1")
        router.wait_until_succeeds("ping -c 5 fc00:c0de::cafe")

      with subtest("Prometheus Exporter"):
        router.systemctl("start prometheus-kea-exporter.service")
        router.wait_for_open_port(9547)
        router.log(router.execute("curl 127.0.0.1:9547")[1])
        # Reservations don't count against this value, so check if it is still 0
        router.succeed("curl --no-buffer 127.0.0.1:9547 | grep -qE '^kea_dhcp6_na_assigned_total.*0.0$'")
    '';
}
