import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "zitadel";

    meta.maintainers = with lib.maintainers; [ bhankas ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;

        environment.etc."zitadel/zitadel.env".text = ''
          foobar
        '';

        services = {
          postgresql = {
            enable = true;
            ensureUsers = [
              {
                name = "postgres";
                ensureClauses = {
                  login = true;
                  superuser = true;
                  createrole = true;
                  createdb = true;
                };
              }
              {
                name = "zitadel";
                ensureClauses = {
                  login = true;
                  createrole = true;
                  createdb = true;
                };
              }
            ];
          };

          zitadel = {
            enable = true;
            package = pkgs.zitadel-bin;
            openFirewall = false;
            tlsMode = "disabled";
            masterKeyFile = "/etc/zitadel/zitadel.env";
            settings = {
              Port = 8080;
              ExternalDomain = "https://foo.bar.com";
            };
            steps = {
              bhankas = {
                InstanceName = "testinstance";
                Org.Human = {
                  UserName = "userName";
                  FirstName = "fName";
                  LastName = "lName";
                };
              };
            };
          };
        };

        systemd.services.zitadel.environment = {
          ZITADEL_DATABASE_POSTGRES_HOST = "localhost";
          ZITADEL_DATABASE_POSTGRES_PORT = "5432";
          ZITADEL_DATABASE_POSTGRES_DATABASE = "zitadel";
          ZITADEL_DATABASE_POSTGRES_USER_USERNAME = "zitadel";
          ZITADEL_DATABASE_POSTGRES_USER_PASSWORD = "zitadel";
          ZITADEL_DATABASE_POSTGRES_USER_SSL_MODE = "disable";
          ZITADEL_DATABASE_POSTGRES_ADMIN_USERNAME = "postgres";
          ZITADEL_DATABASE_POSTGRES_ADMIN_SSL_MODE = "postgres";
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("zitadel.service")
      machine.wait_for_open_port(8080)
      machine.sleep(5)

      with subtest("zitadel bin works"):
          machine.succeed("${lib.getExe pkgs.zitadel-bin} ready")

      with subtest("zitadel service starts"):
          machine.wait_until_succeeds(
              "curl -sSfL http://localhost:8080/ > /dev/null",
              timeout=30
          )
    '';
  }
)
