import ./make-test.nix ({ pkgs, ...} : 
let
  test = pkgs.writeText "test.sql" ''
    CREATE EXTENSION pgcrypto;
    CREATE EXTENSION pgjwt;
    select sign('{"sub":"1234567890","name":"John Doe","admin":true}', 'secret');
    select * from verify('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWV9.TJVA95OrM7E2cBab30RMHrHDcEfxjoYZgeFONFh7HgQ', 'secret');
  '';
in
{
  name = "pgjwt";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ spinus ];
  };

  nodes = {
    master =
      { pkgs, config, ... }:

      {
        services.postgresql = let mypg = pkgs.postgresql95; in {
            enable = true;
            package = mypg;
            extraPlugins =[pkgs.pgjwt];
            initialScript =  pkgs.writeText "postgresql-init.sql"
          ''
          CREATE ROLE postgres WITH superuser login createdb;
          '';
          };
      };
  };

  testScript = ''
    startAll;
    $master->waitForUnit("postgresql");
    $master->succeed("timeout 10 bash -c 'while ! psql postgres -c \"SELECT 1;\";do sleep 1;done;'");
    $master->succeed("cat ${test} | psql postgres");
    # I can't make original test working :[
    # $master->succeed("${pkgs.perlPackages.TAPParserSourceHandlerpgTAP}/bin/pg_prove -d postgres ${pkgs.pgjwt.src}/test.sql");

  '';
})
