{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; }
, ...
}:
let
  lib = pkgs.lib;
  testScript = ''
    machine.start()
    machine.wait_for_unit("ferretdb.service")
    machine.wait_for_open_port(27017)
    machine.succeed("mongosh --eval 'use myNewDatabase;' --eval 'db.myCollection.insertOne( { x: 1 } );'")
  '';
in
with import ../lib/testing-python.nix { inherit system; };
{

  postgresql = makeTest
    {
      inherit testScript;
      name = "ferretdb-postgresql";
      meta.maintainers = with lib.maintainers; [ julienmalka ];

      nodes.machine =
        { pkgs, ... }:
        {
          services.ferretdb = {
            enable = true;
            settings.FERRETDB_HANDLER = "pg";
            settings.FERRETDB_POSTGRESQL_URL = "postgres://ferretdb@localhost/ferretdb?host=/run/postgresql";
          };

          systemd.services.ferretdb.serviceConfig = {
            Requires = "postgresql.service";
            After = "postgresql.service";
          };

          services.postgresql = {
            enable = true;
            ensureDatabases = [ "ferretdb" ];
            ensureUsers = [{
              name = "ferretdb";
              ensureDBOwnership = true;
            }];
          };

          environment.systemPackages = with pkgs; [ mongosh ];
        };
    };

  sqlite = makeTest
    {
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
