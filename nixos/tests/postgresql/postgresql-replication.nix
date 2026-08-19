{
  runTest,
  genTests,
  ...
}:

let

  makeTestFor =
    package:
    runTest (
      { lib, ... }:
      {
        name = "postgresql-replication-${package.name}";
        meta.maintainers = with lib.maintainers; [ bouk ];

        nodes = {
          primary =
            { ... }:
            {
              services.postgresql = {
                inherit package;
                enable = true;
                enableTCPIP = true;
                settings = {
                  wal_level = "replica";
                  max_wal_senders = 10;
                  max_replication_slots = 10;
                };
                authentication = ''
                  local replication postgres peer
                  host replication replication all trust
                '';
                ensureUsers = [
                  {
                    name = "replication";
                    ensureClauses.replication = true;
                  }
                ];
              };
              networking.firewall.allowedTCPPorts = [ 5432 ];
            };

          replica =
            { nodes, ... }:
            {
              services.postgresql = {
                inherit package;
                enable = true;
                settings = {
                  hot_standby = "on";
                  primary_conninfo = "host=${nodes.primary.networking.primaryIPAddress} user=replication";
                  primary_slot_name = "replica_slot";
                };
              };
            };
        };

        testScript = ''
          start_all()
          primary.wait_for_unit("postgresql.target")

          primary.succeed(
              "sudo -u postgres psql -c \"SELECT * FROM pg_create_physical_replication_slot('replica_slot');\""
          )

          primary.succeed(
              "sudo -u postgres pg_basebackup -D /tmp/basebackup -S replica_slot -X stream"
          )
          primary.succeed("tar -C /tmp -cf /tmp/shared/basebackup.tar basebackup")

          replica.wait_for_unit("postgresql.target")
          replica.succeed("systemctl stop postgresql")

          replica_data_dir = "/var/lib/postgresql/${package.psqlSchema}"
          replica.succeed(f"rm -rf {replica_data_dir}")
          replica.succeed(f"mkdir -p {replica_data_dir}")
          replica.succeed(f"tar -C {replica_data_dir} --strip-components=1 -xf /tmp/shared/basebackup.tar")
          replica.succeed(f"touch {replica_data_dir}/standby.signal")
          replica.succeed(f"chown -R postgres:postgres {replica_data_dir}")
          replica.succeed(f"chmod 700 {replica_data_dir}")

          replica.succeed("systemctl start postgresql")
          replica.wait_for_unit("postgresql.target")

          replica.wait_until_succeeds(
              "sudo -u postgres psql -tAc 'SELECT pg_is_in_recovery();' | grep t"
          )

          primary.succeed(
              "sudo -u postgres psql -c 'CREATE TABLE test_replication (id serial PRIMARY KEY, data text);'"
          )
          primary.succeed(
              "sudo -u postgres psql -c \"INSERT INTO test_replication (data) VALUES ('hello');\""
          )

          replica.wait_until_succeeds(
              "sudo -u postgres psql -c 'SELECT * FROM test_replication;' | grep hello",
              timeout=30
          )

          with subtest("Verify replica is in recovery mode"):
              result = replica.succeed("sudo -u postgres psql -tAc 'SELECT pg_is_in_recovery();'")
              t.assertEqual(result.strip(), "t")

          with subtest("Verify replication slot is active"):
              result = primary.succeed(
                  "sudo -u postgres psql -tAc \"SELECT active FROM pg_replication_slots WHERE slot_name = 'replica_slot';\""
              )
              t.assertEqual(result.strip(), "t")

          with subtest("Insert more data and verify replication"):
              primary.succeed(
                  "sudo -u postgres psql -c \"INSERT INTO test_replication (data) VALUES ('world');\""
              )
              replica.wait_until_succeeds(
                  "sudo -u postgres psql -c 'SELECT * FROM test_replication;' | grep world",
                  timeout=30
              )

          primary.shutdown()
          replica.shutdown()
        '';
      }
    );
in
genTests { inherit makeTestFor; }
