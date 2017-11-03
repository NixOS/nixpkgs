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
    CREATE TABLE xmltest ( doc xml );
    INSERT INTO xmltest (doc) VALUES ('<test>ok</test>'); -- check if libxml2 enabled
  '';
  make-postgresql-test = postgresql-name: postgresql-package: makeTest {
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
      sub check_count {
        my ($select, $nlines) = @_;
        return 'test $(sudo -u postgres psql postgres -tAc "' . $select . '"|wc -l) -eq ' . $nlines;
      }

      $machine->start;
      $machine->waitForUnit("postgresql");
      # postgresql should be available just after unit start
      $machine->succeed("cat ${test-sql} | sudo -u postgres psql");
      $machine->shutdown; # make sure that postgresql survive restart (bug #1735)
      sleep(2);
      $machine->start;
      $machine->waitForUnit("postgresql");
      $machine->fail(check_count("SELECT * FROM sth;", 3));
      $machine->succeed(check_count("SELECT * FROM sth;", 5));
      $machine->fail(check_count("SELECT * FROM sth;", 4));
      $machine->succeed(check_count("SELECT xpath(\'/test/text()\', doc) FROM xmltest;", 1));
      $machine->shutdown;
    '';

  };
in
  mapAttrs' (p-name: p-package: {name=p-name; value=make-postgresql-test p-name p-package;}) postgresql-versions
