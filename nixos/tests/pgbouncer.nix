import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "pgbouncer";

    meta = with lib.maintainers; {
      maintainers = [ _1000101 ];
    };

    nodes = {
      one =
        { pkgs, ... }:
        {
          systemd.services.postgresql = {
            postStart = ''
              ${pkgs.postgresql}/bin/psql -U postgres -c "ALTER ROLE testuser WITH LOGIN PASSWORD 'testpass'";
              ${pkgs.postgresql}/bin/psql -U postgres -c "ALTER DATABASE testdb OWNER TO testuser;";
            '';
          };

          services = {
            postgresql = {
              enable = true;
              ensureDatabases = [ "testdb" ];
              ensureUsers = [ { name = "testuser"; } ];
              authentication = ''
                local testdb testuser scram-sha-256
              '';
            };

            pgbouncer = {
              enable = true;
              openFirewall = true;
              settings = {
                pgbouncer = {
                  listen_addr = "localhost";
                  auth_type = "scram-sha-256";
                  auth_file = builtins.toFile "pgbouncer-users.txt" ''
                    "testuser" "testpass"
                  '';
                };
                databases = {
                  test = "host=/run/postgresql port=5432 auth_user=testuser dbname=testdb";
                };
              };
            };
          };
        };
    };

    testScript = ''
      start_all()
      one.wait_for_unit("default.target")
      one.require_unit_state("pgbouncer.service", "active")

      # Test if we can make a query through PgBouncer
      one.wait_until_succeeds(
          "psql 'postgres://testuser:testpass@localhost:6432/test' -c 'SELECT 1;'"
      )
    '';
  }
)
