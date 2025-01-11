import ./make-test-python.nix (
  { pkgs, ... }:
  let
    role = "test";
    password = "secret";
    conn = "local";
  in
  {
    name = "pgmanage";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ basvandijk ];
    };
    nodes = {
      one =
        { config, pkgs, ... }:
        {
          services = {
            postgresql = {
              enable = true;
              initialScript = pkgs.writeText "pg-init-script" ''
                CREATE ROLE ${role} SUPERUSER LOGIN PASSWORD '${password}';
              '';
            };
            pgmanage = {
              enable = true;
              connections = {
                ${conn} =
                  "hostaddr=127.0.0.1 port=${toString config.services.postgresql.settings.port} dbname=postgres";
              };
            };
          };
        };
    };

    testScript = ''
      start_all()
      one.wait_for_unit("default.target")
      one.require_unit_state("pgmanage.service", "active")

      # Test if we can log in.
      one.wait_until_succeeds(
          "curl 'http://localhost:8080/pgmanage/auth' --data 'action=login&connname=${conn}&username=${role}&password=${password}' --fail"
      )
    '';
  }
)
