{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
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
        services.postgresql = {
          enable = true;
          package = postgresql-package;
        };

        services.postgresqlBackup = {
          enable = true;
          databases = optional (!backup-all) "postgres";
        };
      };

    testScript = let
      backupName = if backup-all then "all" else "postgres";
      backupService = if backup-all then "postgresqlBackup" else "postgresqlBackup-postgres";
    in ''
      def check_count(statement, lines):
          return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
              statement, lines
          )


      machine.start()
      machine.wait_for_unit("postgresql")

      with subtest("Postgresql is available just after unit start"):
          machine.succeed(
              "cat ${test-sql} | sudo -u postgres psql"
          )

      with subtest("Postgresql survives restart (bug #1735)"):
          machine.shutdown()
          time.sleep(2)
          machine.start()
          machine.wait_for_unit("postgresql")

      machine.fail(check_count("SELECT * FROM sth;", 3))
      machine.succeed(check_count("SELECT * FROM sth;", 5))
      machine.fail(check_count("SELECT * FROM sth;", 4))
      machine.succeed(check_count("SELECT xpath('/test/text()', doc) FROM xmltest;", 1))

      with subtest("Backup service works"):
          machine.succeed(
              "systemctl start ${backupService}.service",
              "zcat /var/backup/postgresql/${backupName}.sql.gz | grep '<test>ok</test>'",
              "stat -c '%a' /var/backup/postgresql/${backupName}.sql.gz | grep 600",
          )

      with subtest("Initdb works"):
          machine.succeed("sudo -u postgres initdb -D /tmp/testpostgres2")

      machine.shutdown()
    '';

  };
in
  (mapAttrs' (name: package: { inherit name; value=make-postgresql-test name package false;}) postgresql-versions) // {
    postgresql_11-backup-all = make-postgresql-test "postgresql_11-backup-all" postgresql-versions.postgresql_11 true;
  }

