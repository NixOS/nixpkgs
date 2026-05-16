import ../make-test-python.nix (
  { lib, pkgs, ... }:
  let
    domain = "peertube.local";
    port = 9000;
    url = "http://${domain}:${toString port}";
    password = "zw4SqYVdcsXUfRX8aaFX";
    registrationTokenFile = "/etc/peertube-runner-registration-token";
  in
  {
    name = "peertube";
    meta.maintainers = with lib.maintainers; [ izorkin ] ++ lib.teams.ngi.members;

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
          firewall.allowedTCPPorts = [
            5432
            31638
          ];
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

      server =
        { pkgs, ... }:
        {
          environment = {
            etc = {
              "peertube/password-init-root".text = ''
                PT_INITIAL_ROOT_PASSWORD=${password}
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
                {
                  address = "192.168.2.11";
                  prefixLength = 24;
                }
              ];
            };
            extraHosts = ''
              192.168.2.11 ${domain}
            '';
            firewall.allowedTCPPorts = [ port ];
          };

          services.peertube = {
            enable = true;
            localDomain = domain;
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
        environment.systemPackages = [
          pkgs.jq
          pkgs.peertube.cli
        ];
        networking = {
          interfaces.eth1 = {
            ipv4.addresses = [
              {
                address = "192.168.2.12";
                prefixLength = 24;
              }
            ];
          };
          extraHosts = ''
            192.168.2.11 ${domain}
          '';
        };

        services.peertube-runner = {
          enable = true;
          # Don't pull in unneeded dependencies.
          enabledJobTypes = [ "video-studio-transcoding" ];
          instancesToRegister = {
            testServer1 = {
              inherit url registrationTokenFile;
              runnerName = "I'm a test!!!";
            };
            testServer2 = {
              inherit url registrationTokenFile;
              runnerName = "I'm also a test...";
              runnerDescription = "Even more testing?!?!";
            };
          };
        };
        # Will be manually started in test script.
        systemd.services.peertube-runner.wantedBy = lib.mkForce [ ];
      };

    };

    testScript = ''
      start_all()

      database.wait_for_unit("postgresql.target")
      database.wait_for_unit("redis-peertube.service")

      database.wait_for_open_port(5432)
      database.wait_for_open_port(31638)

      server.wait_for_unit("peertube.service")
      server.wait_for_open_port(${toString port})

      # Check if PeerTube is running
      client.succeed("curl --fail ${url}/api/v1/config/about | jq -r '.instance.name' | grep 'PeerTube Test Server'")


      # PeerTube CLI

      client.succeed('peertube-cli auth add -u "${url}" -U "root" --password "${password}"')
      client.succeed('peertube-cli auth list | grep "${url}"')
      client.succeed('peertube-cli auth del "${url}"')
      client.fail('peertube-cli auth list | grep "${url}"')


      # peertube-runner

      access_token = client.succeed(
        'peertube-cli get-access-token --url "${url}" --username "root" --password "${password}"'
      ).strip()
      # Generate registration token.
      client.succeed(f"curl --fail -X POST -H 'Authorization: Bearer {access_token}' ${url}/api/v1/runners/registration-tokens/generate")
      # Get registration token, and put it where `registrationTokenFile` from the
      # peertube-runner module points to.
      client.succeed(
        f"curl --fail -H 'Authorization: Bearer {access_token}' ${url}/api/v1/runners/registration-tokens" \
        " | jq --raw-output '.data[0].registrationToken'" \
        " > ${registrationTokenFile}"
      )

      client.systemctl("start peertube-runner.service")
      client.wait_for_unit("peertube-runner.service")

      runner_command = "sudo -u prunner peertube-runner"
      client.succeed(f'{runner_command} list-registered | grep "I\'m a test!!!"')
      client.succeed(f'{runner_command} list-registered | grep "I\'m also a test..."')
      client.succeed(f'{runner_command} list-registered | grep "Even more testing?!?!"')

      # Service should still work once instances are already registered.
      client.systemctl("restart peertube-runner.service")
      client.wait_for_unit("peertube-runner.service")


      # Cleanup

      client.shutdown()
      server.shutdown()
      database.shutdown()
    '';
  }
)
