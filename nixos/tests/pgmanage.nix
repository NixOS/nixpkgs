import ./make-test.nix ({ pkgs, ... } :
let
  role     = "test";
  password = "secret";
  conn     = "local";
in
{
  name = "pgmanage";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ basvandijk ];
  };
  nodes = {
    one = { config, pkgs, ... }: {
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
            "${conn}" = "hostaddr=127.0.0.1 port=${toString config.services.postgresql.port} dbname=postgres";
          };
        };
      };
    };
  };

  testScript = ''
    startAll;
    $one->waitForUnit("default.target");
    $one->requireActiveUnit("pgmanage.service");

    # Test if we can log in.
    $one->waitUntilSucceeds("curl 'http://localhost:8080/pgmanage/auth' --data 'action=login&connname=${conn}&username=${role}&password=${password}' --fail");
  '';
})
