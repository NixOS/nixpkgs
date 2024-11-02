{ pkgs
, makeTest
}:

let
  inherit (pkgs) lib;

  makePgjwtTest = postgresqlPackage:
    makeTest {
      name = "pgjwt-${postgresqlPackage.name}";
      meta = with lib.maintainers; {
        maintainers = [ spinus willibutz ];
      };

      nodes = {
        master = { ... }:
        {
          services.postgresql = {
            enable = true;
            package = postgresqlPackage;
            extraPlugins = ps: with ps; [ pgjwt pgtap ];
          };
        };
      };

      testScript = { nodes, ... }:
      let
        sqlSU = "${nodes.master.services.postgresql.superUser}";
        pgProve = "${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}";
        inherit (nodes.master.services.postgresql.package.pkgs) pgjwt;
      in
      ''
        start_all()
        master.wait_for_unit("postgresql")
        master.succeed(
            "${pkgs.sudo}/bin/sudo -u ${sqlSU} ${pgProve}/bin/pg_prove -d postgres -v -f ${pgjwt.src}/test.sql"
        )
      '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makePgjwtTest p; }) pkgs.postgresqlVersions
  // {
    passthru.override = p: makePgjwtTest p;
  }
)
