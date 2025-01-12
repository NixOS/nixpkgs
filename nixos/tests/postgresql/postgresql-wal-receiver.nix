{
  pkgs,
  makeTest,
}:

let
  inherit (pkgs) lib;

  makeTestFor =
    package:
    let
      postgresqlDataDir = "/var/lib/postgresql/${package.psqlSchema}";
      replicationUser = "wal_receiver_user";
      replicationSlot = "wal_receiver_slot";
      replicationConn = "postgresql://${replicationUser}@localhost";
      baseBackupDir = "/var/cache/wals/pg_basebackup";
      walBackupDir = "/var/cache/wals/pg_wal";
      recoveryFile = pkgs.writeTextDir "recovery.signal" "";
    in
    makeTest {
      name = "postgresql-wal-receiver-${package.name}";
      meta.maintainers = with lib.maintainers; [ euxane ];

      nodes.machine =
        { ... }:
        {
          systemd.tmpfiles.rules = [
            "d /var/cache/wals 0750 postgres postgres - -"
          ];

          services.postgresql = {
            inherit package;
            enable = true;
            enableJIT = lib.hasInfix "-jit-" package.name;
            settings = {
              max_replication_slots = 10;
              max_wal_senders = 10;
              recovery_end_command = "touch recovery.done";
              restore_command = "cp ${walBackupDir}/%f %p";
              wal_level = "archive"; # alias for replica on pg >= 9.6
            };
            authentication = ''
              host replication ${replicationUser} all trust
            '';
            initialScript = pkgs.writeText "init.sql" ''
              create user ${replicationUser} replication;
              select * from pg_create_physical_replication_slot('${replicationSlot}');
            '';
          };

          services.postgresqlWalReceiver.receivers.main = {
            postgresqlPackage = package;
            connection = replicationConn;
            slot = replicationSlot;
            directory = walBackupDir;
          };
          # This is only to speedup test, it isn't time racing. Service is set to autorestart always,
          # default 60sec is fine for real system, but is too much for a test
          systemd.services.postgresql-wal-receiver-main.serviceConfig.RestartSec = lib.mkForce 5;
          systemd.services.postgresql.serviceConfig.ReadWritePaths = [ "/var/cache/wals" ];
        };

      testScript = ''
        # make an initial base backup
        machine.wait_for_unit("postgresql")
        machine.wait_for_unit("postgresql-wal-receiver-main")
        # WAL receiver healthchecks PG every 5 seconds, so let's be sure they have connected each other
        # required only for 9.4
        machine.sleep(5)
        machine.succeed(
            "${package}/bin/pg_basebackup --dbname=${replicationConn} --pgdata=${baseBackupDir}"
        )

        # create a dummy table with 100 records
        machine.succeed(
            "sudo -u postgres psql --command='create table dummy as select * from generate_series(1, 100) as val;'"
        )

        # stop postgres and destroy data
        machine.systemctl("stop postgresql")
        machine.systemctl("stop postgresql-wal-receiver-main")
        machine.succeed("rm -r ${postgresqlDataDir}/{base,global,pg_*}")

        # restore the base backup
        machine.succeed(
            "cp -r ${baseBackupDir}/* ${postgresqlDataDir} && chown postgres:postgres -R ${postgresqlDataDir}"
        )

        # prepare WAL and recovery
        machine.succeed("chmod a+rX -R ${walBackupDir}")
        machine.execute(
            "for part in ${walBackupDir}/*.partial; do mv $part ''${part%%.*}; done"
        )  # make use of partial segments too
        machine.succeed(
            "cp ${recoveryFile}/* ${postgresqlDataDir}/ && chmod 666 ${postgresqlDataDir}/recovery*"
        )

        # replay WAL
        machine.systemctl("start postgresql")
        machine.wait_for_file("${postgresqlDataDir}/recovery.done")
        machine.systemctl("restart postgresql")
        machine.wait_for_unit("postgresql")

        # check that our records have been restored
        machine.succeed(
            "test $(sudo -u postgres psql --pset='pager=off' --tuples-only --command='select count(distinct val) from dummy;') -eq 100"
        )
      '';
    };
in
lib.recurseIntoAttrs (
  lib.concatMapAttrs (n: p: { ${n} = makeTestFor p; }) pkgs.postgresqlVersions
  // {
    passthru.override = p: makeTestFor p;
  }
)
