import ./make-test.nix ({ pkgs, lib, ...}:

let
  pgjwt = pkgs.postgresqlPackages.pgjwt;
  pg_prove = "${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}/bin/pg_prove";

  test = pkgs.runCommand "test.sql" {} ''
    sed -e '12 i CREATE EXTENSION pgcrypto;\nCREATE EXTENSION pgtap;\nSET search_path TO tap,public;' ${pgjwt.src}/test.sql > $out;
  '';
in
{
  name = "pgjwt";
  meta.maintainers = with lib.maintainers; [ thoughtpolice spinus willibutz ];

  nodes = {
    master = { ... }: {
      services.postgresql = {
        enable = true;
        plugins = p: with p; [ pgjwt pgtap ];
      };
    };
  };

  testScript = { nodes, ... }: ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->copyFileFromHost("${test}","/tmp/test.sql");
    $master->succeed("${pkgs.sudo}/bin/sudo -u postgres PGOPTIONS=--search_path=tap,public ${pg_prove} -v -d postgres -f /tmp/test.sql");
  '';
})
