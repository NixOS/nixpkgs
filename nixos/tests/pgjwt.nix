import ./make-test.nix ({ pkgs, lib, ...}:
let
  test = with pkgs; runCommand "patch-test" {
    nativeBuildInputs = [ pgjwt ];
  }
  ''
    sed -e '12 i CREATE EXTENSION pgcrypto;\nCREATE EXTENSION pgtap;\nSET search_path TO tap,public;' ${pgjwt.src}/test.sql > $out;
  '';
in
with pkgs; {
  name = "pgjwt";
  meta = with lib.maintainers; {
    maintainers = [ spinus willibutz ];
  };

  nodes = {
    master = { pkgs, config, ... }:
    {
      services.postgresql = {
        enable = true;
        extraPlugins = [ pgjwt pgtap ];
      };
    };
  };

  testScript = { nodes, ... }:
  let
    sqlSU = "${nodes.master.config.services.postgresql.superUser}";
    pgProve = "${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}";
  in
  ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->copyFileFromHost("${test}","/tmp/test.sql");
    $master->succeed("${pkgs.sudo}/bin/sudo -u ${sqlSU} PGOPTIONS=--search_path=tap,public ${pgProve}/bin/pg_prove -d postgres -v -f /tmp/test.sql");
  '';
})
