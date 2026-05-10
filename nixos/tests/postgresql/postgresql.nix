{
  runTest,
  genTests,
  lib,
  ...
}:

let
  makeTestFor =
    package:
    lib.recurseIntoAttrs {
      postgresql = makeTestForWithBackupAll package false;
      postgresql-backup-all = makeTestForWithBackupAll package true;
      postgresql-clauses = makeEnsureTestFor package;
    };

  makeTestForWithBackupAll =
    package: backupAll:
    runTest (
      { lib, pkgs, ... }:
      let
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

          -- check if hardening gets relaxed
          CREATE EXTENSION plv8;
          -- try to trigger the V8 JIT, which requires MemoryDenyWriteExecute
          DO $$
            let xs = [];
            for (let i = 0, n = 400000; i < n; i++) {
                xs.push(Math.round(Math.random() * n))
            }
            console.log(xs.reduce((acc, x) => acc + x, 0));
          $$ LANGUAGE plv8;
        '';

      in
      {
        name = "postgresql${lib.optionalString backupAll "-backup-all"}-${package.name}";
        meta = with lib.maintainers; {
          maintainers = [ zagy ];
        };

        nodes.machine =
          { config, ... }:
          {
            services.postgresql = {
              inherit package;
              enable = true;
              identMap = ''
                postgres root postgres
              '';
              # TODO(@Ma27) split this off into its own VM test and move a few other
              # extension tests to use postgresqlTestExtension.
              extensions = ps: with ps; [ plv8 ];
            };

            services.postgresqlBackup = {
              enable = true;
              databases = lib.optional (!backupAll) "postgres";
              pgdumpOptions = "--restrict-key=ABCDEFGHIJKLMNOPQRSTUVWXYZ";
              pgdumpAllOptions = "--restrict-key=ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            };
          };

        testScript =
          let
            backupName = if backupAll then "all" else "postgres";
            backupService = if backupAll then "postgresqlBackup" else "postgresqlBackup-postgres";
            backupFileBase = "/var/backup/postgresql/${backupName}";
          in
          ''
            def check_count(statement, lines):
                return 'test $(psql -U postgres postgres -tAc "{}"|wc -l) -eq {}'.format(
                    statement, lines
                )


            machine.start()
            machine.wait_for_unit("postgresql.target")

            with subtest("Postgresql is available just after unit start"):
                machine.succeed(
                    "cat ${test-sql} | sudo -u postgres psql"
                )

            with subtest("Postgresql survives restart (bug #1735)"):
                machine.shutdown()
                import time
                time.sleep(2)
                machine.start()
                machine.wait_for_unit("postgresql.target")

            machine.fail(check_count("SELECT * FROM sth;", 3))
            machine.succeed(check_count("SELECT * FROM sth;", 5))
            machine.fail(check_count("SELECT * FROM sth;", 4))
            machine.succeed(check_count("SELECT xpath('/test/text()', doc) FROM xmltest;", 1))

            with subtest("killing postgres process should trigger an automatic restart"):
                machine.succeed("systemctl kill -s KILL postgresql")

                machine.wait_until_succeeds("systemctl is-active postgresql.service")
                machine.wait_until_succeeds("systemctl is-active postgresql.target")

            with subtest("Backup service works"):
                machine.succeed(
                    "systemctl start ${backupService}.service",
                    "zcat ${backupFileBase}.sql.gz | grep '<test>ok</test>'",
                    "ls -hal /var/backup/postgresql/ >/dev/console",
                    "stat -c '%a' ${backupFileBase}.sql.gz | grep 600",
                )
            with subtest("Backup service removes prev files"):
                machine.succeed(
                    # Create dummy prev files.
                    "touch ${backupFileBase}.prev.sql{,.gz,.zstd}",
                    "chown postgres:postgres ${backupFileBase}.prev.sql{,.gz,.zstd}",

                    # Run backup.
                    "systemctl start ${backupService}.service",
                    "ls -hal /var/backup/postgresql/ >/dev/console",

                    # Since nothing has changed in the database, the cur and prev files
                    # should match.
                    "zcat ${backupFileBase}.sql.gz | grep '<test>ok</test>'",
                    "cmp ${backupFileBase}.sql.gz ${backupFileBase}.prev.sql.gz",

                    # The prev files with unused suffix should be removed.
                    "[ ! -f '${backupFileBase}.prev.sql' ]",
                    "[ ! -f '${backupFileBase}.prev.sql.zstd' ]",

                    # Both cur and prev file should only be accessible by the postgres user.
                    "stat -c '%a' ${backupFileBase}.sql.gz | grep 600",
                    "stat -c '%a' '${backupFileBase}.prev.sql.gz' | grep 600",
                )
            with subtest("Backup service fails gracefully"):
                # Sabotage the backup process
                machine.succeed("rm /run/postgresql/.s.PGSQL.5432")
                machine.fail(
                    "systemctl start ${backupService}.service",
                )
                machine.succeed(
                    "ls -hal /var/backup/postgresql/ >/dev/console",
                    "zcat ${backupFileBase}.prev.sql.gz | grep '<test>ok</test>'",
                    "stat ${backupFileBase}.in-progress.sql.gz",
                )
                # In a previous version, the second run would overwrite prev.sql.gz,
                # so we test a second run as well.
                machine.fail(
                    "systemctl start ${backupService}.service",
                )
                machine.succeed(
                    "stat ${backupFileBase}.in-progress.sql.gz",
                    "zcat ${backupFileBase}.prev.sql.gz | grep '<test>ok</test>'",
                )


            with subtest("Initdb works"):
                machine.succeed("sudo -u postgres initdb -D /tmp/testpostgres2")

            machine.log(machine.execute("systemd-analyze security postgresql.service | grep -v ✓")[1])

            machine.shutdown()
          '';
      }
    );

  makeEnsureTestFor =
    package:
    runTest (
      { lib, ... }:
      {
        name = "postgresql-clauses-${package.name}";
        meta = with lib.maintainers; {
          maintainers = [ zagy ];
        };

        nodes.machine =
          { ... }:
          {
            services.postgresql = {
              inherit package;
              enable = true;
              ensureUsers = [
                {
                  name = "all-clauses";
                  ensureClauses = {
                    superuser = true;
                    createdb = true;
                    createrole = true;
                    "inherit" = true;
                    login = true;
                    replication = true;
                    bypassrls = true;
                    # SCRAM-SHA-256 hashed password for "password"
                    password = "SCRAM-SHA-256$4096:SZEJF5Si4QZ6l4fedrZZWQ==$6u3PWVcz+dts+NdpByPIjKa4CaSnoXGG3M2vpo76bVU=:WSZ0iGUCmVtKYVvNX0pFOp/60IgsdJ+90Y67Eun+QE0=";
                    connection_limit = 5;
                  };
                }
                {
                  name = "default-clauses";
                }
              ];
            };
          };

        testScript =
          let
            getClausesQuery =
              user:
              lib.concatStringsSep " " [
                "SELECT row_to_json(row)"
                "FROM ("
                "SELECT"
                "rolsuper,"
                "rolinherit,"
                "rolcreaterole,"
                "rolcreatedb,"
                "rolcanlogin,"
                "rolreplication,"
                "rolbypassrls,"
                "rolconnlimit,"
                "rolpassword"
                "FROM pg_authid"
                "WHERE rolname = '${user}'"
                ") row;"
              ];
          in
          ''
            import json
            machine.start()
            machine.wait_for_unit("postgresql.target")

            with subtest("All user permissions are set according to the ensureClauses attr"):
                clauses = json.loads(
                  machine.succeed(
                      "sudo -u postgres psql -tc \"${getClausesQuery "all-clauses"}\""
                  )
                )
                print(clauses)
                t.assertTrue(clauses["rolsuper"])
                t.assertTrue(clauses["rolinherit"])
                t.assertTrue(clauses["rolcreaterole"])
                t.assertTrue(clauses["rolcreatedb"])
                t.assertTrue(clauses["rolcanlogin"])
                t.assertTrue(clauses["rolreplication"])
                t.assertTrue(clauses["rolbypassrls"])
                t.assertTrue(clauses["rolconnlimit"] == 5)
                t.assertTrue(clauses["rolpassword"])
                machine.succeed(
                  "PGPASSWORD='password' psql -h localhost -U all-clauses -d postgres -c \"SELECT 1\""
                )

            with subtest("All user permissions default when ensureClauses is not provided"):
                clauses = json.loads(
                  machine.succeed(
                      "sudo -u postgres psql -tc \"${getClausesQuery "default-clauses"}\""
                  )
                )
                t.assertFalse(clauses["rolsuper"])
                t.assertTrue(clauses["rolinherit"])
                t.assertFalse(clauses["rolcreaterole"])
                t.assertFalse(clauses["rolcreatedb"])
                t.assertTrue(clauses["rolcanlogin"])
                t.assertFalse(clauses["rolreplication"])
                t.assertFalse(clauses["rolbypassrls"])
                t.assertFalse(clauses["rolconnlimit"] == 5)
                t.assertFalse(clauses["rolpassword"])

            machine.shutdown()
          '';
      }
    );
in
genTests { inherit makeTestFor; }
