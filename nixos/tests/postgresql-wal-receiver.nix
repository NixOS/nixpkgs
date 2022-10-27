{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  lib = pkgs.lib;

  # Makes a test for a PostgreSQL package, given by name and looked up from `pkgs`.
  makePostgresqlWalReceiverTest = postgresqlPackage:
  {
    name = postgresqlPackage;
    value =
      let
        pkg = pkgs."${postgresqlPackage}";
        postgresqlDataDir = "/var/lib/postgresql/${pkg.psqlSchema}";
        replicationUser = "wal_receiver_user";
        replicationSlot = "wal_receiver_slot";
        replicationConn = "postgresql://${replicationUser}@localhost";
        baseBackupDir = "/tmp/pg_basebackup";
        walBackupDir = "/tmp/pg_wal";
        atLeast12 = lib.versionAtLeast pkg.version "12.0";

        recoveryFile = if atLeast12
            then pkgs.writeTextDir "recovery.signal" ""
            else pkgs.writeTextDir "recovery.conf" "restore_command = 'cp ${walBackupDir}/%f %p'";

      in makeTest {
        name = "postgresql-wal-receiver-${postgresqlPackage}";
        meta.maintainers = with lib.maintainers; [ pacien ];

        nodes.machine = { ... }: {
          services.postgresql = {
            package = pkg;
            enable = true;
            settings = lib.mkMerge [
              {
                wal_level = "archive"; # alias for replica on pg >= 9.6
                max_wal_senders = 10;
                max_replication_slots = 10;
              }
              (lib.mkIf atLeast12 {
                restore_command = "cp ${walBackupDir}/%f %p";
                recovery_end_command = "touch recovery.done";
              })
            ];
            authentication = ''
              host replication ${replicationUser} all trust
            '';
            initialScript = pkgs.writeText "init.sql" ''
              create user ${replicationUser} replication;
              select * from pg_create_physical_replication_slot('${replicationSlot}');
            '';
          };

          services.postgresqlWalReceiver.receivers.main = {
            postgresqlPackage = pkg;
            connection = replicationConn;
            slot = replicationSlot;
            directory = walBackupDir;
          };
          # This is only to speedup test, it isn't time racing. Service is set to autorestart always,
          # default 60sec is fine for real system, but is too much for a test
          systemd.services.postgresql-wal-receiver-main.serviceConfig.RestartSec = lib.mkForce 5;
        };

        testScript = ''
          # make an initial base backup
          machine.wait_for_unit("postgresql")
          machine.wait_for_unit("postgresql-wal-receiver-main")
          # WAL receiver healthchecks PG every 5 seconds, so let's be sure they have connected each other
          # required only for 9.4
          machine.sleep(5)
          machine.succeed(
              "${pkg}/bin/pg_basebackup --dbname=${replicationConn} --pgdata=${baseBackupDir}"
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
    };

# Maps the generic function over all attributes of PostgreSQL packages
in builtins.listToAttrs (map makePostgresqlWalReceiverTest (builtins.attrNames (import ../../pkgs/servers/sql/postgresql { })))
