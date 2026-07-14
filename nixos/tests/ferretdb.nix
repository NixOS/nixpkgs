{ runTest, pkgs }:
let
  inherit (pkgs) lib;
  testScript = ''
    machine.start()
    machine.wait_for_unit("ferretdb.service")
    machine.wait_for_open_port(27017)
    machine.succeed("mongosh --eval 'use myNewDatabase;' --eval 'db.myCollection.insertOne( { x: 1 } );'")
  '';
in
{
  postgresql = runTest {
    inherit testScript;
    name = "ferretdb-postgresql";
    meta.maintainers = with lib.maintainers; [ julienmalka ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.ferretdb = {
          enable = true;
          settings.FERRETDB_HANDLER = "pg";
        };

        systemd.services.ferretdb.serviceConfig = {
          Requires = "postgresql.target";
          After = "postgresql.target";
        };

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "ferretdb" ];
          ensureUsers = [
            {
              name = "ferretdb";
              ensureDBOwnership = true;
            }
          ];
        };

        environment.systemPackages = with pkgs; [ mongosh ];
      };
  };
  sqlite = runTest {
    inherit testScript;
    name = "ferretdb-sqlite";
    meta.maintainers = with lib.maintainers; [ julienmalka ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.ferretdb.enable = true;

        environment.systemPackages = with pkgs; [ mongosh ];
      };
  };
}
