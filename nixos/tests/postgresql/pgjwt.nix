{
  pkgs,
  makeTest,
  genTests,
}:

let
  inherit (pkgs) lib;

  makeTestFor =
    package:
    makeTest {
      name = "pgjwt-${package.name}";
      meta = with lib.maintainers; {
        maintainers = [
          spinus
        ];
      };

      nodes.master =
        { ... }:
        {
          services.postgresql = {
            inherit package;
            enable = true;
            extensions =
              ps: with ps; [
                pgjwt
                pgtap
              ];
          };
        };

      testScript =
        { nodes, ... }:
        let
          sqlSU = "${nodes.master.services.postgresql.superUser}";
          pgProve = "${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}";
          inherit (nodes.master.services.postgresql.package.pkgs) pgjwt;
        in
        ''
          start_all()
          master.wait_for_unit("postgresql.target")
          master.succeed(
              "${pkgs.sudo}/bin/sudo -u ${sqlSU} ${pgProve}/bin/pg_prove -d postgres -v -f ${pgjwt.src}/test.sql"
          )
        '';
    };
in
genTests {
  inherit makeTestFor;
  filter = _: p: !p.pkgs.pgjwt.meta.broken;
}
