import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "turnstone";
    meta.maintainers = with lib.maintainers; [ timvherpen ];

    nodes.sqlite =
      { pkgs, ... }:
      {
        virtualisation.cores = 4;
        virtualisation.memorySize = 4096;

        services.turnstone = {
          # This intentionally places the secret in the Nix store, which is
          # world-readable. That is acceptable for VM-based integration tests.
          jwtSecretFile = "${pkgs.writeText "jwt-secret" "0000000000000000000000000000000000000000000000000000000000000000"}";

          server = {
            enable = true;
            port = 8080;
            settings.database.backend = "sqlite";
          };

          console = {
            enable = true;
            port = 8090;
            settings.database.backend = "sqlite";
          };
        };
      };

    nodes.postgresql =
      { pkgs, ... }:
      {
        virtualisation.cores = 4;
        virtualisation.memorySize = 4096;

        services.turnstone = {
          # This intentionally places the secret in the Nix store, which is
          # world-readable. That is acceptable for VM-based integration tests.
          jwtSecretFile = "${pkgs.writeText "jwt-secret" "0000000000000000000000000000000000000000000000000000000000000000"}";

          server = {
            enable = true;
            port = 8080;
            settings.database.backend = "postgresql";
          };
        };
      };

    testScript = ''
      start_all()

      # --- SQLite node ---

      with subtest("sqlite: wait for services to start"):
          sqlite.wait_for_unit("turnstone-server.service")
          sqlite.wait_for_open_port(8080)

          sqlite.wait_for_unit("turnstone-console.service")
          sqlite.wait_for_open_port(8090)

      with subtest("sqlite: check if server is responding"):
          sqlite.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080 | grep -E '^(200|401|403|404)$'")

      with subtest("sqlite: check if console is responding"):
          sqlite.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8090 | grep -E '^(200|401|403|404)$'")

      with subtest("sqlite: service user exists"):
          sqlite.succeed("id turnstone")

      with subtest("sqlite: config file permissions"):
          sqlite.succeed("stat -c '%a' /var/lib/turnstone/config.toml | grep -q '600'")

      with subtest("sqlite: state directory ownership"):
          sqlite.succeed("stat -c '%U:%G' /var/lib/turnstone | grep -q 'turnstone:turnstone'")

      # --- PostgreSQL node ---

      with subtest("postgresql: wait for services to start"):
          postgresql.wait_for_unit("postgresql.service")
          postgresql.wait_for_unit("turnstone-server.service")
          postgresql.wait_for_open_port(8080)

      with subtest("postgresql: check if server is responding"):
          postgresql.succeed("curl -s -o /dev/null -w '%{http_code}' http://127.0.0.1:8080 | grep -E '^(200|401|403|404)$'")

      with subtest("postgresql: database exists"):
          postgresql.succeed("sudo -u postgres psql -lqt | grep -q turnstone")
    '';
  }
)
