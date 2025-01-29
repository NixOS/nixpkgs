{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  makeTestFor =
    package:
    lib.recurseIntoAttrs {
      postgresql = makeTestForWithBackupAll package false;
      postgresql-backup-all = makeTestForWithBackupAll package true;
      postgresql-clauses = makeEnsureTestFor package;
    };

  test-sql =
    enablePLv8Test:
    pkgs.writeText "postgresql-test" (
      ''
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
      ''
      + lib.optionalString enablePLv8Test ''
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
      ''
    );

  makeTestForWithBackupAll =
    package: backupAll:
    let
      enablePLv8Check = !package.pkgs.plv8.meta.broken;
    in
    makeTest {
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
            enableJIT = lib.hasInfix "-jit-" package.name;
            # plv8 doesn't support postgresql with JIT, so we only run the test
            # for the non-jit variant.
            # TODO(@Ma27) split this off into its own VM test and move a few other
            # extension tests to use postgresqlTestExtension.
            extensions = lib.mkIf enablePLv8Check (ps: with ps; [ plv8 ]);
          };

          services.postgresqlBackup = {
            enable = true;
            databases = lib.optional (!backupAll) "postgres";
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
              return 'test $(sudo -u postgres psql postgres -tAc "{}"|wc -l) -eq {}'.format(
                  statement, lines
              )


          machine.start()
          machine.wait_for_unit("postgresql")

          with subtest("Postgresql is available just after unit start"):
              machine.succeed(
                  "cat ${test-sql enablePLv8Check} | sudo -u postgres psql"
              )

          with subtest("Postgresql survives restart (bug #1735)"):
              machine.shutdown()
              import time
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
    };

  makeEnsureTestFor =
    package:
    makeTest {
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
            enableJIT = lib.hasInfix "-jit-" package.name;
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
              "rolbypassrls"
              "FROM pg_roles"
              "WHERE rolname = '${user}'"
              ") row;"
            ];
        in
        ''
          import json
          machine.start()
          machine.wait_for_unit("postgresql")

          with subtest("All user permissions are set according to the ensureClauses attr"):
              clauses = json.loads(
                machine.succeed(
                    "sudo -u postgres psql -tc \"${getClausesQuery "all-clauses"}\""
                )
              )
              print(clauses)
              assert clauses['rolsuper'], 'expected user with clauses to have superuser clause'
              assert clauses['rolinherit'], 'expected user with clauses to have inherit clause'
              assert clauses['rolcreaterole'], 'expected user with clauses to have create role clause'
              assert clauses['rolcreatedb'], 'expected user with clauses to have create db clause'
              assert clauses['rolcanlogin'], 'expected user with clauses to have login clause'
              assert clauses['rolreplication'], 'expected user with clauses to have replication clause'
              assert clauses['rolbypassrls'], 'expected user with clauses to have bypassrls clause'

          with subtest("All user permissions default when ensureClauses is not provided"):
              clauses = json.loads(
                machine.succeed(
                    "sudo -u postgres psql -tc \"${getClausesQuery "default-clauses"}\""
                )
              )
              assert not clauses['rolsuper'], 'expected user with no clauses set to have default superuser clause'
              assert clauses['rolinherit'], 'expected user with no clauses set to have default inherit clause'
              assert not clauses['rolcreaterole'], 'expected user with no clauses set to have default create role clause'
              assert not clauses['rolcreatedb'], 'expected user with no clauses set to have default create db clause'
              assert clauses['rolcanlogin'], 'expected user with no clauses set to have default login clause'
              assert not clauses['rolreplication'], 'expected user with no clauses set to have default replication clause'
              assert not clauses['rolbypassrls'], 'expected user with no clauses set to have default bypassrls clause'

          machine.shutdown()
        '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) pkgs.postgresqlVersions
  // {
    passthru.override = p: makeTestFor p;
  }
)
