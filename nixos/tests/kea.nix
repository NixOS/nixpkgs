# This test verifies DHCPv4 interaction between a client and a router.
# For successful DHCP allocations a dynamic update request is sent
# towards a nameserver to allocate a name in the lan.nixos.test zone.
# We then verify whether client and router can ping each other, and
# that the nameserver can resolve the clients fqdn to the correct IP
# address.

{
  pkgs,
  lib,
  ...
}:
{
  meta.maintainers = with lib.maintainers; [ hexa ];

  name = "kea";

  nodes = {
    router =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useDHCP = false;
          firewall.allowedUDPPorts = [ 67 ];
        };

        systemd.network = {
          enable = true;
          networks = {
            "01-eth1" = {
              name = "eth1";
              networkConfig = {
                Address = "10.0.0.1/29";
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

            control-socket = {
              socket-type = "unix";
              socket-name = "/run/kea/dhcp4.sock";
            };

            interfaces-config = {
              dhcp-socket-type = "raw";
              interfaces = [
                "eth1"
              ];
            };

            subnet4 = [
              {
                id = 1;
                subnet = "10.0.0.0/29";
                pools = [
                  {
                    pool = "10.0.0.3 - 10.0.0.3";
                  }
                ];
              }
            ];

            # Enable communication between dhcp4 and a local dhcp-ddns
            # instance.
            # https://kea.readthedocs.io/en/kea-2.2.0/arm/dhcp4-srv.html#ddns-for-dhcpv4
            dhcp-ddns = {
              enable-updates = true;
            };

            ddns-send-updates = true;
            ddns-qualifying-suffix = "lan.nixos.test.";
          };
        };

        services.kea.dhcp-ddns = {
          enable = true;
          settings = {
            forward-ddns = {
              # Configure updates of a forward zone named `lan.nixos.test`
              # hosted at the nameserver at 10.0.0.2
              # https://kea.readthedocs.io/en/kea-2.2.0/arm/ddns.html#adding-forward-dns-servers
              ddns-domains = [
                {
                  name = "lan.nixos.test.";
                  # Use a TSIG key in production!
                  key-name = "";
                  dns-servers = [
                    {
                      ip-address = "10.0.0.2";
                      port = 53;
                    }
                  ];
                }
              ];
            };
          };
        };

        services.kea.ctrl-agent = {
          enable = true;
          settings = {
            http-host = "127.0.0.1";
            http-port = 8000;
            control-sockets.dhcp4 = {
              socket-type = "unix";
              socket-name = "/run/kea/dhcp4.sock";
            };
          };
        };

        services.prometheus.exporters.kea = {
          enable = true;
          controlSocketPaths = [
            "http://127.0.0.1:8000"
          ];
        };
      };

    nameserver =
      { config, pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useDHCP = false;
          firewall.allowedUDPPorts = [ 53 ];
        };

        systemd.network = {
          enable = true;
          networks = {
            "01-eth1" = {
              name = "eth1";
              networkConfig = {
                Address = "10.0.0.2/29";
              };
            };
          };
        };

        services.resolved.enable = false;

        # Set up an authoritative nameserver, serving the `lan.nixos.test`
        # zone and configure an ACL that allows dynamic updates from
        # the router's ip address.
        # This ACL is likely insufficient for production usage. Please
        # use TSIG keys.
        services.knot =
          let
            zone = pkgs.writeTextDir "lan.nixos.test.zone" ''
              @ SOA ns.nixos.test nox.nixos.test 0 86400 7200 3600000 172800
              @ NS nameserver
              nameserver A 10.0.0.3
              router A 10.0.0.1
            '';
            zonesDir = pkgs.buildEnv {
              name = "knot-zones";
              paths = [ zone ];
            };
          in
          {
            enable = true;
            extraArgs = [
              "-v"
            ];
            settings = {
              server.listen = [
                "0.0.0.0@53"
              ];

              log.syslog.any = "info";

              acl.dhcp_ddns = {
                address = "10.0.0.1";
                action = "update";
              };

              template.default = {
                storage = zonesDir;
                zonefile-sync = "-1";
                zonefile-load = "difference-no-serial";
                journal-content = "all";
              };

              zone."lan.nixos.test" = {
                file = "lan.nixos.test.zone";
                acl = [
                  "dhcp_ddns"
                ];
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
      router.wait_for_unit("kea-dhcp4-server.service")
      client.systemctl("start systemd-networkd-wait-online.service")
      client.wait_for_unit("systemd-networkd-wait-online.service")
      client.wait_until_succeeds("ping -c 5 10.0.0.1")
      router.wait_until_succeeds("ping -c 5 10.0.0.3")
      nameserver.wait_until_succeeds("kdig +short client.lan.nixos.test @10.0.0.2 | grep -q 10.0.0.3")
      router.log(router.execute("curl 127.0.0.1:9547")[1])
      router.succeed("curl --no-buffer 127.0.0.1:9547 | grep -qE '^kea_dhcp4_addresses_assigned_total.*1.0$'")
    '';
}
