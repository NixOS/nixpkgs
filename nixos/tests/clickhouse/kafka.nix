{ pkgs, package, ... }:

let
  kafkaNamedCollectionConfig = ''
    <clickhouse>
      <named_collections>
        <cluster_1>
            <!-- ClickHouse Kafka engine parameters -->
            <kafka_broker_list>kafka:9092</kafka_broker_list>
            <kafka_topic_list>test_topic</kafka_topic_list>
            <kafka_group_name>clickhouse</kafka_group_name>
            <kafka_format>JSONEachRow</kafka_format>
            <kafka_commit_every_batch>0</kafka_commit_every_batch>
            <kafka_num_consumers>1</kafka_num_consumers>
            <kafka_thread_per_consumer>1</kafka_thread_per_consumer>

            <!-- Kafka extended configuration -->
            <kafka>
              <debug>all</debug>
              <auto_offset_reset>earliest</auto_offset_reset>
            </kafka>
        </cluster_1>
      </named_collections>
    </clickhouse>
  '';

  kafkaNamedCollection = pkgs.writeText "kafka.xml" kafkaNamedCollectionConfig;
in
{
  name = "clickhouse-kafka";
  meta.maintainers = with pkgs.lib.maintainers; [
    jpds
    thevar1able
  ];

  nodes = {
    clickhouse = {
      environment.etc = {
        "clickhouse-server/config.d/kafka.xml" = {
          source = "${kafkaNamedCollection}";
        };
      };

      services.clickhouse = {
        enable = true;
        inherit package;
      };
      virtualisation.memorySize = 4096;
    };

    kafka = {
      networking.firewall.allowedTCPPorts = [
        9092
        9093
      ];

      environment.systemPackages = [
        pkgs.apacheKafka
        pkgs.jq
      ];

      services.apache-kafka = {
        enable = true;

        # Randomly generated uuid. You can get one by running:
        # kafka-storage.sh random-uuid
        clusterId = "b81s-MuGSwyt_B9_h37wtQ";

        formatLogDirs = true;

        settings = {
          listeners = [
            "PLAINTEXT://:9092"
            "CONTROLLER://:9093"
          ];
          "listener.security.protocol.map" = [
            "PLAINTEXT:PLAINTEXT"
            "CONTROLLER:PLAINTEXT"
          ];
          "controller.quorum.voters" = [
            "1@kafka:9093"
          ];
          "controller.listener.names" = [ "CONTROLLER" ];

          "node.id" = 1;
          "broker.rack" = 1;

          "process.roles" = [
            "broker"
            "controller"
          ];

          "log.dirs" = [ "/var/lib/apache-kafka" ];
          "num.partitions" = 1;
          "offsets.topic.replication.factor" = 1;
          "transaction.state.log.replication.factor" = 1;
          "transaction.state.log.min.isr" = 1;
        };
      };

      systemd.services.apache-kafka.serviceConfig.StateDirectory = "apache-kafka";

      virtualisation.memorySize = 1024 * 2;
    };
  };

  testScript =
    let
      jsonTestMessage = pkgs.writeText "kafka-test-data.json" ''
        { "id": 1, "first_name": "Fred", "age": 32 }
        { "id": 2, "first_name": "Barbara", "age": 30 }
        { "id": 3, "first_name": "Nicola", "age": 12 }
      '';
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      tableKafkaDDL = pkgs.writeText "ddl-kafka.sql" ''
        CREATE TABLE `test_kafka_topic` (
          `id` UInt32,
          `first_name` String,
          `age` UInt32
        ) ENGINE = Kafka(cluster_1);
      '';

      tableDDL = pkgs.writeText "ddl.sql" ''
        CREATE TABLE `test_topic` (
          `id` UInt32,
          `first_name` String,
          `age` UInt32
        ) ENGINE = MergeTree ORDER BY id;
      '';

      viewDDL = pkgs.writeText "view.sql" ''
        CREATE MATERIALIZED VIEW kafka_view TO test_topic AS
        SELECT
            id,
            first_name,
            age,
        FROM test_kafka_topic;
      '';
      selectQuery = pkgs.writeText "select.sql" "SELECT sum(age) from `test_topic`";
    in
    ''
      kafka.start()
      kafka.wait_for_unit("apache-kafka")
      kafka.wait_for_open_port(9092)

      clickhouse.start()
      clickhouse.wait_for_unit("clickhouse")
      clickhouse.wait_for_open_port(9000)

      clickhouse.wait_until_succeeds(
        """
          journalctl -o cat -u clickhouse.service | grep "Merging configuration file '/etc/clickhouse-server/config.d/kafka.xml'"
        """
      )

      clickhouse.succeed(
        "cat ${tableKafkaDDL} | clickhouse-client"
      )

      clickhouse.succeed(
        "cat ${tableDDL} | clickhouse-client"
      )

      clickhouse.succeed(
        "cat ${viewDDL} | clickhouse-client"
      )

      kafka.succeed(
        "jq -rc . ${jsonTestMessage} | kafka-console-producer.sh --topic test_topic --bootstrap-server kafka:9092"
      )

      kafka.wait_until_succeeds(
        "journalctl -o cat -u apache-kafka.service | grep 'Created a new member id ClickHouse-clickhouse-default-test_kafka_topic'"
      )

      clickhouse.wait_until_succeeds(
        "cat ${selectQuery} | clickhouse-client | grep 74"
      )
    '';
}
