{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  makePostgresqlWalReceiverTest = subTestName: postgresqlPackage: let

  postgresqlDataDir = "/var/db/postgresql/test";
  replicationUser = "wal_receiver_user";
  replicationSlot = "wal_receiver_slot";
  replicationConn = "postgresql://${replicationUser}@localhost";
  baseBackupDir = "/tmp/pg_basebackup";
  walBackupDir = "/tmp/pg_wal";
  atLeast12 = versionAtLeast postgresqlPackage.version "12.0";
  restoreCommand = ''
    restore_command = 'cp ${walBackupDir}/%f %p'
  '';

  recoveryFile = if atLeast12
      then pkgs.writeTextDir "recovery.signal" ""
      else pkgs.writeTextDir "recovery.conf" "${restoreCommand}";

  in makeTest {
    name = "postgresql-wal-receiver-${subTestName}";
    meta.maintainers = with maintainers; [ pacien ];

    machine = { ... }: {
      # Needed because this test uses a non-default 'services.postgresql.dataDir'.
      systemd.tmpfiles.rules = [
        "d /var/db/postgresql 0700 postgres postgres"
      ];
      services.postgresql = {
        package = postgresqlPackage;
        enable = true;
        dataDir = postgresqlDataDir;
        extraConfig = ''
          wal_level = archive # alias for replica on pg >= 9.6
          max_wal_senders = 10
          max_replication_slots = 10
        '' + optionalString atLeast12 ''
          ${restoreCommand}
          recovery_end_command = 'touch recovery.done'
        '';
        authentication = ''
          host replication ${replicationUser} all trust
        '';
        initialScript = pkgs.writeText "init.sql" ''
          create user ${replicationUser} replication;
          select * from pg_create_physical_replication_slot('${replicationSlot}');
        '';
      };

      services.postgresqlWalReceiver.receivers.main = {
        inherit postgresqlPackage;
        connection = replicationConn;
        slot = replicationSlot;
        directory = walBackupDir;
      };
      # This is only to speedup test, it isn't time racing. Service is set to autorestart always,
      # default 60sec is fine for real system, but is too much for a test
      systemd.services.postgresql-wal-receiver-main.serviceConfig.RestartSec = mkForce 5;
    };

    testScript = ''
      # make an initial base backup
      $machine->waitForUnit('postgresql');
      $machine->waitForUnit('postgresql-wal-receiver-main');
      # WAL receiver healthchecks PG every 5 seconds, so let's be sure they have connected each other
      # required only for 9.4
      $machine->sleep(5);
      $machine->succeed('${postgresqlPackage}/bin/pg_basebackup --dbname=${replicationConn} --pgdata=${baseBackupDir}');

      # create a dummy table with 100 records
      $machine->succeed('sudo -u postgres psql --command="create table dummy as select * from generate_series(1, 100) as val;"');

      # stop postgres and destroy data
      $machine->systemctl('stop postgresql');
      $machine->systemctl('stop postgresql-wal-receiver-main');
      $machine->succeed('rm -r ${postgresqlDataDir}/{base,global,pg_*}');

      # restore the base backup
      $machine->succeed('cp -r ${baseBackupDir}/* ${postgresqlDataDir} && chown postgres:postgres -R ${postgresqlDataDir}');

      # prepare WAL and recovery
      $machine->succeed('chmod a+rX -R ${walBackupDir}');
      $machine->execute('for part in ${walBackupDir}/*.partial; do mv $part ''${part%%.*}; done'); # make use of partial segments too
      $machine->succeed('cp ${recoveryFile}/* ${postgresqlDataDir}/ && chmod 666 ${postgresqlDataDir}/recovery*');

      # replay WAL
      $machine->systemctl('start postgresql');
      $machine->waitForFile('${postgresqlDataDir}/recovery.done');
      $machine->systemctl('restart postgresql');
      $machine->waitForUnit('postgresql');

      # check that our records have been restored
      $machine->succeed('test $(sudo -u postgres psql --pset="pager=off" --tuples-only --command="select count(distinct val) from dummy;") -eq 100');
    '';
  };

in mapAttrs makePostgresqlWalReceiverTest (import ../../pkgs/servers/sql/postgresql pkgs)
