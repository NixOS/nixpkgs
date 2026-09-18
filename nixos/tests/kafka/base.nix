{
  pkgs,
  runTest,
  lib,
  ...
}:

with lib;

let
  makeKafkaTest =
    name:
    { kafkaPackage }:
    (runTest {
      inherit name;

      nodes = {
        kafka =
          { ... }:
          {
            services.apache-kafka = {
              enable = true;
              package = kafkaPackage;
              clusterId = "ak2fIHr4S8WWarOF_ODD0g";
              formatLogDirs = true;
              settings = {
                "offsets.topic.replication.factor" = 1;
                "log.dirs" = [
                  "/var/lib/kafka/logdir1"
                  "/var/lib/kafka/logdir2"
                ];
                "node.id" = 1;
                "process.roles" = [
                  "broker"
                  "controller"
                ];
                "listeners" = [
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
              };
            };

            networking.firewall.allowedTCPPorts = [
              9092
              9093
            ];
            virtualisation.diskSize = 1024;
            # i686 tests: qemu-system-i386 can simulate max 2047MB RAM (not 2048)
            virtualisation.memorySize = 2047;
          };
      };

      testScript = ''
        start_all()

        kafka.wait_for_unit("default.target")
        kafka.wait_for_unit("apache-kafka.service")
        kafka.wait_for_open_port(9092)

        kafka.wait_until_succeeds(
            "${kafkaPackage}/bin/kafka-topics.sh --create "
            + "--bootstrap-server localhost:9092 --partitions 1 "
            + "--replication-factor 1 --topic testtopic"
        )
        kafka.succeed(
            "echo 'test 1' | "
            + "${kafkaPackage}/bin/kafka-console-producer.sh "
            + "--bootstrap-server localhost:9092 --topic testtopic"
        )
        assert "test 1" in kafka.succeed(
            "${kafkaPackage}/bin/kafka-console-consumer.sh "
            + "--bootstrap-server localhost:9092 --topic testtopic "
            + "--from-beginning --max-messages 1"
        )
      '';
    });

in
with pkgs;
{
  kafka_4_1 = makeKafkaTest "kafka_4_1" { kafkaPackage = apacheKafka_4_1; };
  kafka_4_2 = makeKafkaTest "kafka_4_2" { kafkaPackage = apacheKafka_4_2; };
  kafka_4_3 = makeKafkaTest "kafka_4_3" { kafkaPackage = apacheKafka_4_3; };
  kafka = makeKafkaTest "kafka" { kafkaPackage = apacheKafka; };
}
