{ pkgs, lib, ... }:
{
  name = "netbox-kea";

  nodes = {
    server = {
      environment.etc."netbox/secret.key".text = ''
        secretsecretsecretsecretsecretsecretsecretsecret00
      '';

      services = {
        postgresql = {
          enable = true;
          ensureDatabases = [ "netbox" ];
          ensureUsers = [
            {
              name = "netbox";
              ensureDBOwnership = true;
            }
          ];
        };

        netbox = {
          enable = true;
          secretKeyFile = "/etc/netbox/secret.key";
          plugins = ps: [ ps.netbox-kea ];
          settings.PLUGINS = [ "netbox_kea" ];
        };

        kea = {
          ctrl-agent = {
            enable = true;
            settings = {
              # see https://kea.readthedocs.io/en/kea-2.6.2/arm/agent.html
              http-host = "127.0.0.1";
              http-port = 8000;
              authentication = {
                type = "basic";
                realm = "kea-control-agent";
                clients = [
                  {
                    user = "admin";
                    password = "1234";
                  }
                ];
              };
              control-sockets.dhcp4 = {
                comment = "main server";
                socket-type = "unix";
                socket-name = "/run/kea/kea4-ctrl-socket";
              };
            };
          };
          dhcp4 = {
            enable = true;
            settings = {
              interfaces-config.interfaces = [ "eth1" ];
              control-socket = {
                socket-type = "unix";
                socket-name = "/run/kea/kea4-ctrl-socket";
              };
              hooks-libraries = [
                {
                  library = "${pkgs.kea}/lib/kea/hooks/libdhcp_lease_cmds.so";
                }
              ];
              subnet4 = [
                {
                  id = 1;
                  subnet = "192.0.2.0/24";
                  pools = [
                    {
                      pool = "192.0.2.100-192.0.2.199";
                    }
                  ];
                }
              ];
            };
          };
        };
      };

      # initial django database migrations exceeds default timeout
      systemd.services.netbox.serviceConfig.TimeoutStartSec = "10min";
    };
    client = {
      networking.interfaces = {
        # prevent creation of default route from management network
        eth0.useDHCP = false;
        eth1 = {
          ipv4.addresses = lib.mkForce [ ];
          ipv6.addresses = lib.mkForce [ ];
          useDHCP = true;
        };
      };
    };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("netbox.service")
    server.wait_for_open_port(8001)

    server.wait_for_unit("kea-dhcp4-server.service")
    server.wait_for_unit("kea-ctrl-agent.service")
    server.wait_for_open_port(8000)

    with subtest("access kea control agent without proper authorisation"):
        server.succeed("""
          curl -s -X POST \
            -H 'Content-Type: application/json' \
            -d '{"command": "list-commands"}' \
            http://localhost:8000/ \
            | ${lib.getExe pkgs.jq} -r '.text' \
            | grep 'Unauthorized'
        """)

    with subtest("access kea control agent"):
        server.succeed("""
          curl -s -X POST \
            -H 'Content-Type: application/json' \
            -u admin:1234 \
            -d '{"command": "list-commands"}' \
            http://localhost:8000/ \
            | ${lib.getExe pkgs.jq} -r '.[].arguments.[]' \
            | ${lib.getExe' pkgs.busybox "xargs"} \
            | grep 'status-get'
        """)

    with subtest("get dhcp leases from kea control agent"):
        print(server.succeed("""
          curl -s -X POST \
            -H 'Content-Type: application/json' \
            -u admin:1234 \
            -d '{"command": "lease4-get-all", "service": ["dhcp4"]}' \
            http://localhost:8000/ \
            | ${lib.getExe pkgs.jq} -r '.[].arguments.[] | length' \
            | grep '0'
        """))

        client.start()
        # TODO not working
        client.wait_for_unit("dhcpcd.service")
        client.succeed("ip -br a | grep -E 'eth1.*192.0.2.1[0-9]{2}'")

        print(server.succeed("""
          curl -s -X POST \
            -H 'Content-Type: application/json' \
            -u admin:1234 \
            -d '{"command": "lease4-get-all", "service": ["dhcp4"]}' \
            http://localhost:8000/ \
            | ${lib.getExe pkgs.jq} -r '.[].arguments.[] | length' \
            | grep '1'
        """))

    with subtest("plugin is installed"):
        server.succeed("${lib.getExe pkgs.netbox} shell -c 'from django.conf import settings; print(settings.PLUGINS)' | grep netbox_kea")

    with subtest("plugin is working"):
        server.succeed("""
          ${lib.getExe pkgs.netbox} shell <<_EOF
          from netbox_kea.models import Server
          Server.objects.create(
              name="test-kea-server",
              server_url="http://127.0.0.1:8000",
              username="admin",
              password="1234",
              ssl_verify=False,
              dhcp4=True,
              dhcp6=False
          )
          _EOF
        """)

        # TODO check leases (should be one from previous test)
  '';

  meta.maintainers = with lib.maintainers; [ felbinger ];
}
