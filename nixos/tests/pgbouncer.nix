import ./make-test-python.nix (
  { pkgs, ... }:
  let
    testAuthFile = pkgs.writeTextFile {
      name = "authFile";
      text = ''
        "testuser" "testpass"
      '';
    };
  in
  {
    name = "pgbouncer";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ _1000101 ];
    };
    nodes = {
      one =
        { config, pkgs, ... }:
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
              ensureUsers = [
                {
                  name = "testuser";
                }
              ];
              authentication = ''
                local testdb testuser scram-sha-256
              '';
            };

            pgbouncer = {
              enable = true;
              listenAddress = "localhost";
              databases = {
                test = "host=/run/postgresql/ port=5432 auth_user=testuser dbname=testdb";
              };
              authType = "scram-sha-256";
              authFile = testAuthFile;
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
