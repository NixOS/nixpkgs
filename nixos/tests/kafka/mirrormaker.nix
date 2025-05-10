import ../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    inherit (lib) mkMerge;

    # Generate with `kafka-storage.sh random-uuid`
    clusterAId = "ihzlrasUQ9O3Yy0ZWYkd6w";

    clusterBId = "Bnu_zrzKRH6-7KcK7t3I5Q";

    kafkaConfig = {
      networking.firewall.allowedTCPPorts = [
        9092
        9093
      ];

      virtualisation.diskSize = 1024;
      virtualisation.memorySize = 1024 * 2;

      environment.systemPackages = [ pkgs.apacheKafka ];

      services.apache-kafka = {
        enable = true;

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
          "controller.listener.names" = [ "CONTROLLER" ];

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

      systemd.services.apache-kafka = {
        after = [ "network-online.target" ];
        requires = [ "network-online.target" ];
        serviceConfig.StateDirectory = "apache-kafka";
      };
    };

    extraKafkaConfig = {
      kafkaa1 = {
        services.apache-kafka = {
          clusterId = "${clusterAId}";

          settings = {
            "node.id" = 1;
            "controller.quorum.voters" = [ "1@kafkaa1:9093" ];
          };
        };
      };

      kafkab1 = {
        services.apache-kafka = {
          clusterId = "${clusterBId}";

          settings = {
            "node.id" = 1;
            "controller.quorum.voters" = [ "1@kafkab1:9093" ];
          };
        };
      };
    };

    kafkaNodes = builtins.mapAttrs (
      _: val:
      mkMerge [
        val
        kafkaConfig
      ]
    ) extraKafkaConfig;

    mirrorMakerProperties = pkgs.writeText "mm2.properties" ''
      name = A->B

      clusters = A, B

      A.bootstrap.servers = kafkaa1:9092
      B.bootstrap.servers = kafkab1:9092

      A->B.enabled = true
      A->B.topics = .*

      B->A.enabled = false
      B->A.topics = .*

      replication.factor=1
      replication.policy.class=org.apache.kafka.connect.mirror.IdentityReplicationPolicy

      tasks.max = 2
      refresh.topics.enabled = true
      refresh.topics.interval.seconds = 5
      sync.topic.configs.enabled = true

      checkpoints.topic.replication.factor=1
      heartbeats.topic.replication.factor=1
      offset-syncs.topic.replication.factor=1

      offset.storage.replication.factor=1
      status.storage.replication.factor=1
      config.storage.replication.factor=1

      emit.checkpoints.enabled = true
      emit.checkpoints.interval.seconds = 5
    '';
  in
  {
    name = "kafka-mirrormaker";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jpds ];
    };

    nodes = {
      inherit (kafkaNodes) kafkaa1 kafkab1;

      mirrormaker =
        { config, ... }:
        {
          virtualisation.diskSize = 1024;
          virtualisation.memorySize = 1024 * 2;

          # Define a mirrormaker systemd service
          systemd.services.kafka-connect-mirror-maker = {
            after = [ "network-online.target" ];
            requires = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];

            serviceConfig = {
              ExecStart = ''
                ${pkgs.apacheKafka}/bin/connect-mirror-maker.sh ${mirrorMakerProperties}
              '';
              Restart = "on-failure";
              RestartSec = "5s";
            };
          };
        };
    };

    testScript = ''
      import json

      for machine in kafkaa1, kafkab1:
        machine.wait_for_unit("apache-kafka")

      for machine in kafkaa1, kafkab1:
        machine.wait_for_open_port(9092)
        machine.wait_for_open_port(9093)

        machine.wait_until_succeeds(
          "journalctl -o cat -u apache-kafka.service | grep 'Transition from STARTING to STARTED'"
        )

        machine.wait_until_succeeds(
          "journalctl -o cat -u apache-kafka.service | grep 'Kafka Server started'"
        )

      for machine in kafkaa1, kafkab1:
        current_voters_json = machine.wait_until_succeeds(
          f"kafka-metadata-quorum.sh --bootstrap-server {machine.name}:9092 describe --status | grep CurrentVoters"
        ).replace("CurrentVoters:", "")

        voters = json.loads(current_voters_json)

        assert len(voters) == 1

      mirrormaker.wait_for_unit("kafka-connect-mirror-maker")

      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'Kafka MirrorMaker initializing'"
      )
      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'Targeting clusters \[A, B\]'"
      )
      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'INFO \[Worker clientId=A->B, groupId=A-mm2\] Finished starting connectors and tasks'"
      )

      mirrormaker.wait_until_succeeds(
        """
          journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'INFO \[MirrorSourceConnector\|task-0\] \[Producer clientId=A->B\|A->B-0\|offset-syncs-source-producer\] Cluster ID: ${clusterAId}'
        """
      )

      kafkaa1.wait_until_succeeds(
        "journalctl -o cat -u apache-kafka.service | grep 'Stabilized group B-mm2'"
      )

      kafkab1.wait_until_succeeds(
        "journalctl -o cat -u apache-kafka.service | grep 'Stabilized group A-mm2'"
      )

      kafkaa1.wait_until_succeeds(
        "kafka-topics.sh --bootstrap-server localhost:9092 --create --topic test-mm-1 --partitions 1 --replication-factor 1"
      )

      for machine in kafkaa1, kafkab1:
        machine.succeed(
          "kafka-topics.sh --bootstrap-server localhost:9092 --list | grep 'test-mm-1'"
        )

      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'replicating [[:digit:]]\+ topic-partitions A->B: \[test-mm-1-0\]'"
      )

      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'Found [[:digit:]]\+ new topic-partitions on A'"
      )

      kafkaa1.wait_until_succeeds(
        "kafka-verifiable-producer.sh --bootstrap-server kafkaa1:9092 --throughput 10 --max-messages 100 --topic test-mm-1"
      )

      mirrormaker.wait_until_succeeds(
        "journalctl -o cat -u kafka-connect-mirror-maker.service | grep 'Committing offsets for [[:digit:]]\+ acknowledged messages'"
      )

      kafkab1.wait_until_succeeds(
        "kafka-verifiable-consumer.sh --bootstrap-server kafkab1:9092 --topic test-mm-1 --group-id testreplication --max-messages 100"
      )
    '';
  }
)
