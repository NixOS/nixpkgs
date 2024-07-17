import ./make-test-python.nix (
  { pkgs, lib, ... }:

  with pkgs;
  {
    name = "pgjwt";
    meta = with lib.maintainers; {
      maintainers = [
        spinus
        willibutz
      ];
    };

    nodes = {
      master =
        { ... }:
        {
          services.postgresql = {
            enable = true;
            extraPlugins =
              ps: with ps; [
                pgjwt
                pgtap
              ];
          };
        };
    };

    testScript =
      { nodes, ... }:
      let
        sqlSU = "${nodes.master.config.services.postgresql.superUser}";
        pgProve = "${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}";
      in
      ''
        start_all()
        master.wait_for_unit("postgresql")
        master.succeed(
            "${pkgs.gnused}/bin/sed -e '12 i CREATE EXTENSION pgcrypto;\\nCREATE EXTENSION pgtap;\\nSET search_path TO tap,public;' ${pgjwt.src}/test.sql > /tmp/test.sql"
        )
        master.succeed(
            "${pkgs.sudo}/bin/sudo -u ${sqlSU} PGOPTIONS=--search_path=tap,public ${pgProve}/bin/pg_prove -d postgres -v -f /tmp/test.sql"
        )
      '';
  }
)
