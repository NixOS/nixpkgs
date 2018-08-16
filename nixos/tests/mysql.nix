{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
let
  packages = {
    mysql = pkgs.mysql;
    mariadb = pkgs.mariadb;
  };

  make-mysql-test = package: makeTest {
    name = "mysql";
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ eelco chaoflow shlevy ];
    };

    nodes = {
      master =
        { pkgs, ... }:

        {
          services.mysql.enable = true;
          services.mysql.initialDatabases = [ { name = "testdb"; schema = ./testdb.sql; } ];
          services.mysql.package = package;
        };
    };

    testScript = ''
      startAll;

      $master->waitForUnit("mysql");
      $master->succeed("echo 'use testdb; select * from tests' | mysql -u root -N | grep 4");
    '';
  };
in
  pkgs.lib.mapAttrs' (name: pkg: { inherit name; value = make-mysql-test pkg; }) packages
