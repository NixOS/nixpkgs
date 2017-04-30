{ system ? builtins.currentSystem }:
with import ../lib/testing.nix { inherit system; };
with pkgs.lib;
let
  postgresql-versions = pkgs.callPackages ../../pkgs/servers/sql/postgresql { };
  test-sql = pkgs.writeText "postgresql-test" ''
    CREATE EXTENSION pgcrypto; -- just to check if lib loading works
    CREATE TABLE sth (
      id int
    );
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
    INSERT INTO sth (id) VALUES (1);
  '';
  make-postgresql-test = postgresql-name: postgresql-package: {
    name = postgresql-name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ zagy ];
    };

    machine = {pkgs, config, ...}:
      {
        services.postgresql.package=postgresql-package;
        services.postgresql.enable = true;
      };

    testScript = ''
      $machine->start;
      $machine->waitForUnit("postgresql");
      # postgresql should be available just after unit start
      $machine->succeed("cat ${test-sql} | psql postgres");
      $machine->shutdown; # make sure that postgresql survive restart (bug #1735)
      sleep(2);
      $machine->start;
      $machine->waitForUnit("postgresql");
      $machine->fail('test $(psql postgres -tAc "SELECT * FROM sth;"|wc -l) -eq 3');
      $machine->succeed('test $(psql postgres -tAc "SELECT * FROM sth;"|wc -l) -eq 5');
      $machine->fail('test $(psql postgres -tAc "SELECT * FROM sth;"|wc -l) -eq 4');
      $machine->shutdown;
    '';

  };
in
  mapAttrs' (p-name: p-package: {name=p-name; value=make-postgresql-test p-name p-package;}) postgresql-versions
