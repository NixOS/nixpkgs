{ pkgs, ... }:
{
  name = "db-rest";
  meta.maintainers = with pkgs.lib.maintainers; [ marie ];

  nodes = {
    database = {
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.2.10";
              prefixLength = 24;
            }
          ];
        };
        firewall.allowedTCPPorts = [ 31638 ];
      };

      services.redis.servers.db-rest = {
        enable = true;
        bind = "0.0.0.0";
        requirePass = "choochoo";
        port = 31638;
      };
    };

    serverWithTcp =
      { pkgs, ... }:
      {
        environment = {
          etc = {
            "db-rest/password-redis-db".text = ''
              choochoo
            '';
          };
        };

        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.11";
                prefixLength = 24;
              }
            ];
          };
          firewall.allowedTCPPorts = [ 3000 ];
        };

        services.db-rest = {
          enable = true;
          host = "0.0.0.0";
          redis = {
            enable = true;
            createLocally = false;
            host = "192.168.2.10";
            port = 31638;
            passwordFile = "/etc/db-rest/password-redis-db";
            useSSL = false;
          };
        };
      };

    serverWithUnixSocket =
      { pkgs, ... }:
      {
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.12";
                prefixLength = 24;
              }
            ];
          };
          firewall.allowedTCPPorts = [ 3000 ];
        };

        services.db-rest = {
          enable = true;
          host = "0.0.0.0";
          redis = {
            enable = true;
            createLocally = true;
          };
        };
      };

    client = {
      environment.systemPackages = [ pkgs.jq ];
      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            {
              address = "192.168.2.13";
              prefixLength = 24;
            }
          ];
        };
      };
    };
  };

  testScript = ''
    start_all()

    with subtest("db-rest redis with TCP socket"):
      database.wait_for_unit("redis-db-rest.service")
      database.wait_for_open_port(31638)

      serverWithTcp.wait_for_unit("db-rest.service")
      serverWithTcp.wait_for_open_port(3000)

      client.succeed("curl --fail --get http://192.168.2.11:3000/stations --data-urlencode 'query=Köln Hbf' | jq -r '.\"8000207\".name' | grep 'Köln Hbf'")

    with subtest("db-rest redis with Unix socket"):
      serverWithUnixSocket.wait_for_unit("db-rest.service")
      serverWithUnixSocket.wait_for_open_port(3000)

      client.succeed("curl --fail --get http://192.168.2.12:3000/stations --data-urlencode 'query=Köln Hbf' | jq -r '.\"8000207\".name' | grep 'Köln Hbf'")
  '';
}
