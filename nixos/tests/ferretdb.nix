{
  system ? builtins.currentSystem,
  pkgs ? import ../.. { inherit system; },
  ...
}:
let
  lib = pkgs.lib;
  testScript = ''
    machine.start()
    machine.wait_for_unit("ferretdb.service")
    machine.wait_for_open_port(27017)
    machine.succeed("mongosh -u ferretdb -p ferretdb --eval 'use myNewDatabase;' --eval 'db.myCollection.insertOne( { x: 1 } );'")
  '';
in
with import ../lib/testing-python.nix { inherit system; };
{

  postgresql = makeTest {
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
          Requires = "postgresql.service";
          After = "postgresql.service";
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
          extensions =
            ps: with ps; [
              documentdb-ferretdb
              pg_cron
              pgvector
              postgis
              rum
            ];

            settings = {
              "documentdb.enableLetAndCollationForQueryMatch"  = true;
              "documentdb.enableNowSystemVariable"             = true;
              "documentdb.enableSortbyIdPushDownToPrimaryKey"  = true;
              "documentdb.enableSchemaValidation"              = true;
              "documentdb.enableBypassDocumentValidation"      = true;
              "documentdb.enableUserCrud"                      = true;
              "documentdb.maxUserLimit"                        = 100;
              shared_preload_libraries = "pg_cron,pg_documentdb_core,pg_documentdb";
            };
        };

        environment.systemPackages = with pkgs; [ mongosh ];
      };
  };
}
