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

    postgresql_dirmode_change =
      let dataDir = "/db";
    in makeTest {
      name = "postgresql_dirmode_change";
      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = [ danbst ];
      };

      machine = { config, lib, ...}:
        {
          services.postgresql.enable = true;
          services.postgresql.package = pkgs.postgresql_10;
          services.postgresql.dataDir = dataDir;

          users.users.admin.isNormalUser = true;
          users.users.admin.extraGroups = [ "postgres" ];

          nesting.clone = [
            {
              systemd.services.postgresql.preStart = lib.mkAfter ''
                chmod 0700 ${dataDir}
              '';
              systemd.services.postgresql.postStart = lib.mkAfter ''
                chmod -R 750 ${dataDir}
                ${pkgs.acl}/bin/setfacl -d -m g::r-x ${dataDir}
              '';
            }
          ];
        };
    testScript = { nodes, ... }: let
      c1 = "${nodes.machine.config.system.build.toplevel}/fine-tune/child-1";
    in ''
      $machine->start;
      $machine->waitForUnit("postgresql");
      $machine->succeed("echo select 1 | sudo -u postgres psql");

      # by default, mode is 0700
      $machine->fail("sudo -u admin ls ${dataDir}");

      $machine->succeed("${c1}/bin/switch-to-configuration test >&2");
      $machine->succeed("journalctl -u postgresql | grep -q -i stopped"); # was restarted
      $machine->succeed("systemctl restart postgresql"); # but we have to be sure
                                                         # manual restart works too
      $machine->waitForUnit("postgresql");
      $machine->succeed("echo select 1 | sudo -u postgres psql"); # works after restart
      $machine->succeed("sudo -u admin ls ${dataDir}");

      $machine->shutdown;
    '';
    };
  }

