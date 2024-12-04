import ../make-test-python.nix (
  { lib, pkgs, ... }:

  let
    inherit (lib) mkMerge;

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

        # Randomly generated uuid. You can get one by running:
        # kafka-storage.sh random-uuid
        clusterId = "pHG8aWuXSfWAibHFDCnsCQ";

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
            "1@kafka1:9093"
            "2@kafka2:9093"
            "3@kafka3:9093"
            "4@kafka4:9093"
          ];
          "controller.listener.names" = [ "CONTROLLER" ];

          "process.roles" = [
            "broker"
            "controller"
          ];

          "log.dirs" = [ "/var/lib/apache-kafka" ];
          "num.partitions" = 6;
          "offsets.topic.replication.factor" = 2;
          "transaction.state.log.replication.factor" = 2;
          "transaction.state.log.min.isr" = 2;
        };
      };

      systemd.services.apache-kafka.serviceConfig.StateDirectory = "apache-kafka";
    };

    extraKafkaConfig = {
      kafka1 = {
        services.apache-kafka.settings = {
          "node.id" = 1;
          "broker.rack" = 1;
        };
      };

      kafka2 = {
        services.apache-kafka.settings = {
          "node.id" = 2;
          "broker.rack" = 2;
        };
      };

      kafka3 = {
        services.apache-kafka.settings = {
          "node.id" = 3;
          "broker.rack" = 3;
        };
      };

      kafka4 = {
        services.apache-kafka.settings = {
          "node.id" = 4;
          "broker.rack" = 3;
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
  in
  {
    name = "kafka-cluster";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ jpds ];
    };

    nodes = {
      inherit (kafkaNodes)
        kafka1
        kafka2
        kafka3
        kafka4
        ;

      client =
        { config, ... }:
        {
          environment.systemPackages = [ pkgs.apacheKafka ];
          virtualisation.diskSize = 1024;
        };
    };

    testScript = ''
      for machine in kafka1, kafka2, kafka3, kafka4:
        machine.wait_for_unit("apache-kafka")

      client.wait_for_unit("network-online.target")

      for machine in kafka1, kafka2, kafka3, kafka4:
        machine.wait_for_open_port(9092)
        machine.wait_for_open_port(9093)

        machine.wait_until_succeeds(
          "journalctl -o cat -u apache-kafka.service | grep 'Transition from STARTING to STARTED'"
        )

        machine.wait_until_succeeds(
          "journalctl -o cat -u apache-kafka.service | grep 'Kafka Server started'"
        )

      kafka1.wait_until_succeeds(
        "kafka-metadata-quorum.sh --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 describe --status | "
        + "grep -i 'CurrentVoters:[[:blank:]]\+\[1,2,3,4\]'"
      )

      kafka1.wait_until_succeeds(
        "kafka-topics.sh --bootstrap-server kafka1:9092 --create --topic test-123 --replication-factor 2"
      )

      kafka1.wait_until_succeeds(
        "journalctl -o cat -u apache-kafka.service | grep 'CreatableTopic' | grep 'SUCCESS'"
      )

      for machine in kafka1, kafka2, kafka3, kafka4:
        machine.wait_until_succeeds(
          "journalctl -o cat -u apache-kafka.service | grep -E 'Created log for partition test-123-[[:digit:]] in /var/lib/apache-kafka/test-123-[[:digit:]] with properties'"
        )

      kafka1.wait_until_succeeds(
        "kafka-topics.sh --bootstrap-server=kafka1:9092 --describe --topic test-123 | "
        + "grep 'PartitionCount: 6'"
      )

      # Should never see a replica on both 3 and 4 as they're in the same rack
      kafka1.fail(
        "kafka-topics.sh --bootstrap-server=kafka1:9092 --describe --topic test-123 | "
        + "grep -E 'Replicas: (3,4|4,3)'"
      )

      client.succeed(
          "echo 'test 2' | "
          + "kafka-console-producer.sh "
          + "--broker-list kafka1:9092 --topic test-123"
      )
      assert "test 2" in client.succeed(
          "kafka-console-consumer.sh "
          + "--bootstrap-server kafka2:9092 --topic test-123 "
          + "--group readtest "
          + "--from-beginning --max-messages 1"
      )

      client.succeed(
          "echo 'test 3' | "
          + "kafka-console-producer.sh "
          + "--broker-list kafka2:9092 --topic test-123"
      )
      assert "test 3" in client.succeed(
          "kafka-console-consumer.sh "
          + "--bootstrap-server kafka3:9092 --topic test-123 "
          + "--group readtest "
          + "--max-messages 1"
      )
    '';
  }
)
