import ../make-test-python.nix ({pkgs, ...}:
{
  name = "peertube";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes = {
    database = {
      networking = {
       interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.10"; prefixLength = 24; }
          ];
        };
        firewall.allowedTCPPorts = [ 5432 31638 ];
      };

      services.postgresql = {
        enable = true;
        enableTCPIP = true;
        ensureDatabases = [ "peertube_test" ];
        ensureUsers = [
          {
            name = "peertube_test";
            ensureDBOwnership = true;
          }
        ];
        authentication = ''
          hostnossl peertube_test peertube_test 192.168.2.11/32 md5
        '';
        initialScript = pkgs.writeText "postgresql_init.sql" ''
          CREATE ROLE peertube_test LOGIN PASSWORD '0gUN0C1mgST6czvjZ8T9';
        '';
      };

      services.redis.servers.peertube = {
        enable = true;
        bind = "0.0.0.0";
        requirePass = "turrQfaQwnanGbcsdhxy";
        port = 31638;
      };
    };

    server = { pkgs, ... }: {
      environment = {
        etc = {
          "peertube/password-init-root".text = ''
            PT_INITIAL_ROOT_PASSWORD=zw4SqYVdcsXUfRX8aaFX
          '';
          "peertube/secrets-peertube".text = ''
            063d9c60d519597acef26003d5ecc32729083965d09181ef3949200cbe5f09ee
          '';
          "peertube/password-posgressql-db".text = ''
            0gUN0C1mgST6czvjZ8T9
          '';
          "peertube/password-redis-db".text = ''
            turrQfaQwnanGbcsdhxy
          '';
        };
      };

      networking = {
        interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.11"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.11 peertube.local
        '';
        firewall.allowedTCPPorts = [ 9000 ];
      };

      services.peertube = {
        enable = true;
        localDomain = "peertube.local";
        enableWebHttps = false;

        serviceEnvironmentFile = "/etc/peertube/password-init-root";

        secrets = {
          secretsFile = "/etc/peertube/secrets-peertube";
        };

        database = {
          host = "192.168.2.10";
          name = "peertube_test";
          user = "peertube_test";
          passwordFile = "/etc/peertube/password-posgressql-db";
        };

        redis = {
          host = "192.168.2.10";
          port = 31638;
          passwordFile = "/etc/peertube/password-redis-db";
        };

        settings = {
          listen = {
            hostname = "0.0.0.0";
          };
          instance = {
            name = "PeerTube Test Server";
          };
        };
      };
    };

    client = {
      environment.systemPackages = [ pkgs.jq pkgs.peertube.cli ];
      networking = {
       interfaces.eth1 = {
          ipv4.addresses = [
            { address = "192.168.2.12"; prefixLength = 24; }
          ];
        };
        extraHosts = ''
          192.168.2.11 peertube.local
        '';
      };
    };

  };

  testScript = ''
    start_all()

    database.wait_for_unit("postgresql.service")
    database.wait_for_unit("redis-peertube.service")

    database.wait_for_open_port(5432)
    database.wait_for_open_port(31638)

    server.wait_for_unit("peertube.service")
    server.wait_for_open_port(9000)

    # Check if PeerTube is running
    client.succeed("curl --fail http://peertube.local:9000/api/v1/config/about | jq -r '.instance.name' | grep 'PeerTube\ Test\ Server'")

    # Check PeerTube CLI version
    client.succeed('peertube-cli auth add -u "http://peertube.local:9000" -U "root" --password "zw4SqYVdcsXUfRX8aaFX"')
    client.succeed('peertube-cli auth list | grep "http://peertube.local:9000"')
    client.succeed('peertube-cli auth del "http://peertube.local:9000"')
    client.fail('peertube-cli auth list | grep "http://peertube.local:9000"')

    client.shutdown()
    server.shutdown()
    database.shutdown()
  '';
})
