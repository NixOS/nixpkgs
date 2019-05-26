{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  postgresql-versions = import ../../pkgs/servers/sql/postgresql pkgs;
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
  make-postgresql-test = postgresql-name: postgresql-package: backup-all: makeTest {
    name = postgresql-name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ zagy ];
    };

    machine = {...}:
      {
        services.postgresql.enable = true;
        services.postgresql.package = postgresql-package;

        services.postgresqlBackup.enable = true;
        services.postgresqlBackup.databases = optional (!backup-all) "postgres";
      };

    testScript = let
      backupName = if backup-all then "all" else "postgres";
      backupService = if backup-all then "postgresqlBackup" else "postgresqlBackup-postgres";
    in ''
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

      # Check backup service
      $machine->succeed("systemctl start ${backupService}.service");
      $machine->succeed("zcat /var/backup/postgresql/${backupName}.sql.gz | grep '<test>ok</test>'");
      $machine->succeed("stat -c '%a' /var/backup/postgresql/${backupName}.sql.gz | grep 600");
      $machine->shutdown;
    '';

  };
in
  (mapAttrs' (name: package: { inherit name; value=make-postgresql-test name package false;}) postgresql-versions) // {
    postgresql_11-backup-all = make-postgresql-test "postgresql_11-backup-all" postgresql-versions.postgresql_11 true;
  }

