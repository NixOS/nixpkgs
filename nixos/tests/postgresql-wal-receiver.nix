{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; } }:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  postgresqlDataDir = "/var/db/postgresql/test";
  replicationUser = "wal_receiver_user";
  replicationSlot = "wal_receiver_slot";
  replicationConn = "postgresql://${replicationUser}@localhost";
  baseBackupDir = "/tmp/pg_basebackup";
  walBackupDir = "/tmp/pg_wal";
  recoveryConf = pkgs.writeText "recovery.conf" ''
    restore_command = 'cp ${walBackupDir}/%f %p'
  '';

  makePostgresqlWalReceiverTest = subTestName: postgresqlPackage: makeTest {
    name = "postgresql-wal-receiver-${subTestName}";
    meta.maintainers = with maintainers; [ pacien ];

    machine = { ... }: {
      services.postgresql = {
        package = postgresqlPackage;
        enable = true;
        dataDir = postgresqlDataDir;
        extraConfig = ''
          wal_level = archive # alias for replica on pg >= 9.6
          max_wal_senders = 10
          max_replication_slots = 10
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
      $machine->succeed('cp ${recoveryConf} ${postgresqlDataDir}/recovery.conf && chmod 666 ${postgresqlDataDir}/recovery.conf');

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
