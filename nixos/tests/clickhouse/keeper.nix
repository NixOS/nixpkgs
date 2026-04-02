{
  lib,
  pkgs,
  package,
  ...
}:
rec {
  name = "clickhouse-keeper";
  meta.maintainers = with pkgs.lib.maintainers; [
    jpds
    thevar1able
  ];

  nodes =
    let
      node = i: {

        environment.etc = {
          "clickhouse-server/config.d/cluster.xml".text = ''
            <clickhouse>
              <remote_servers>
                <perftest_2shards_1replicas>
                  ${lib.concatStrings (
                    lib.imap0 (j: name: ''
                      <shard>
                        <replica>
                            <host>${name}</host>
                            <port>9000</port>
                        </replica>
                      </shard>
                    '') (builtins.attrNames nodes)
                  )}
                </perftest_2shards_1replicas>
              </remote_servers>
            </clickhouse>
          '';

          "clickhouse-server/config.d/keeper.xml".text = ''
            <clickhouse>
              <keeper_server>
                <server_id>${toString i}</server_id>
                <tcp_port>9181</tcp_port>
                <log_storage_path>/var/lib/clickhouse/coordination/log</log_storage_path>
                <snapshot_storage_path>/var/lib/clickhouse/coordination/snapshots</snapshot_storage_path>

                <coordination_settings>
                  <operation_timeout_ms>10000</operation_timeout_ms>
                  <session_timeout_ms>30000</session_timeout_ms>
                  <raft_logs_level>trace</raft_logs_level>
                  <rotate_log_storage_interval>10000</rotate_log_storage_interval>
                </coordination_settings>

                <raft_configuration>
                  ${lib.concatStrings (
                    lib.imap1 (j: name: ''
                      <server>
                        <id>${toString j}</id>
                        <hostname>${name}</hostname>
                        <port>9444</port>
                      </server>
                    '') (builtins.attrNames nodes)
                  )}
                </raft_configuration>
              </keeper_server>

              <zookeeper>
                ${lib.concatStrings (
                  lib.imap0 (j: name: ''
                    <node>
                      <host>${name}</host>
                      <port>9181</port>
                    </node>
                  '') (builtins.attrNames nodes)
                )}
              </zookeeper>

              <distributed_ddl>
                <path>/clickhouse/testcluster/task_queue/ddl</path>
              </distributed_ddl>
            </clickhouse>
          '';

          "clickhouse-server/config.d/listen.xml".text = ''
            <clickhouse>
              <listen_host>::</listen_host>
            </clickhouse>
          '';

          "clickhouse-server/config.d/macros.xml".text = ''
            <clickhouse>
              <macros>
                  <replica>${toString i}</replica>
                  <cluster>perftest_2shards_1replicas</cluster>
              </macros>
            </clickhouse>
          '';
        };

        networking.firewall.allowedTCPPorts = [
          9009
          9181
          9444
        ];

        services.clickhouse = {
          enable = true;
          inherit package;
        };

        systemd.services.clickhouse = {
          after = [ "network-online.target" ];
          requires = [ "network-online.target" ];
        };

        virtualisation.memorySize = 1024 * 4;
        virtualisation.diskSize = 1024 * 10;
      };
    in
    {
      clickhouse1 = node 1;
      clickhouse2 = node 2;
    };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      clustersQuery = pkgs.writeText "clusters.sql" "SHOW clusters";
      keeperQuery = pkgs.writeText "keeper.sql" "SELECT * FROM system.zookeeper WHERE path IN ('/', '/clickhouse') FORMAT VERTICAL";
      systemClustersQuery = pkgs.writeText "system-clusters.sql" "SELECT host_name, host_address, replica_num FROM system.clusters WHERE cluster = 'perftest_2shards_1replicas'";

      tableDDL = pkgs.writeText "table.sql" ''
        CREATE TABLE test ON cluster 'perftest_2shards_1replicas'   ( A Int64, S String)
        Engine = ReplicatedMergeTree('/clickhouse/{cluster}/tables/{database}/{table}', '{replica}')
        ORDER BY A;
      '';

      insertDDL = pkgs.writeText "insert.sql" "
          INSERT INTO test SELECT number, '' FROM numbers(100000000);
        ";

      selectCountQuery = pkgs.writeText "select-count.sql" "
          select count() from test;
        ";
    in
    ''
      clickhouse1.start()
      clickhouse2.start()

      for machine in clickhouse1, clickhouse2:
        machine.wait_for_unit("clickhouse.service")
        machine.wait_for_open_port(9000)
        machine.wait_for_open_port(9009)
        machine.wait_for_open_port(9181)
        machine.wait_for_open_port(9444)

        machine.wait_until_succeeds(
          """
            journalctl -o cat -u clickhouse.service | grep "Merging configuration file '/etc/clickhouse-server/config.d/keeper.xml'"
          """
        )

        machine.log(machine.succeed(
          "cat ${clustersQuery} | clickhouse-client | grep perftest_2shards_1replicas"
        ))

        machine.log(machine.succeed(
          "cat ${keeperQuery} | clickhouse-client"
        ))

        machine.succeed(
          "cat ${systemClustersQuery} | clickhouse-client | grep clickhouse1"
        )
        machine.succeed(
          "cat ${systemClustersQuery} | clickhouse-client | grep clickhouse2"
        )

        machine.succeed(
          "ls /var/lib/clickhouse/coordination/log | grep changelog"
        )

      clickhouse2.succeed(
        "cat ${tableDDL} | clickhouse-client"
      )

      clickhouse2.succeed(
        "cat ${insertDDL} | clickhouse-client"
      )

      for machine in clickhouse1, clickhouse2:
        machine.wait_until_succeeds(
          "cat ${selectCountQuery} | clickhouse-client | grep 100000000"
        )
    '';
}
