import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "vikunja";

  meta.maintainers = with lib.maintainers; [ leona ];

  nodes = {
    vikunjaSqlite = { ... }: {
      services.vikunja = {
        enable = true;
        database = {
          type = "sqlite";
        };
        frontendScheme = "http";
        frontendHostname = "localhost";
      };
      services.nginx.enable = true;
    };
    vikunjaPostgresql = { pkgs, ... }: {
      services.vikunja = {
        enable = true;
        database = {
          type = "postgres";
          user = "vikunja-api";
          database = "vikunja-api";
          host = "/run/postgresql";
        };
        frontendScheme = "http";
        frontendHostname = "localhost";
        port = 9090;
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "vikunja-api" ];
        ensureUsers = [
          { name = "vikunja-api";
            ensureDBOwnership = true;
          }
        ];
      };
      services.nginx.enable = true;
    };
  };

  testScript =
    ''
      vikunjaSqlite.wait_for_unit("vikunja-api.service")
      vikunjaSqlite.wait_for_open_port(3456)
      vikunjaSqlite.succeed("curl --fail http://localhost:3456/api/v1/info")

      vikunjaSqlite.wait_for_unit("nginx.service")
      vikunjaSqlite.wait_for_open_port(80)
      vikunjaSqlite.succeed("curl --fail http://localhost/api/v1/info")
      vikunjaSqlite.succeed("curl --fail http://localhost")

      vikunjaPostgresql.wait_for_unit("vikunja-api.service")
      vikunjaPostgresql.wait_for_open_port(9090)
      vikunjaPostgresql.succeed("curl --fail http://localhost:9090/api/v1/info")

      vikunjaPostgresql.wait_for_unit("nginx.service")
      vikunjaPostgresql.wait_for_open_port(80)
      vikunjaPostgresql.succeed("curl --fail http://localhost/api/v1/info")
      vikunjaPostgresql.succeed("curl --fail http://localhost")
    '';
})
