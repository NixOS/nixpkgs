{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with pkgs.lib;

let
  makeKafkaTest = name: { kafkaPackage, mode ? "zookeeper" }: (import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes = {
      kafka = { ... }: {
        services.apache-kafka = mkMerge [
          ({
            enable = true;
            package = kafkaPackage;
            settings = {
              "offsets.topic.replication.factor" = 1;
              "log.dirs" = [
                "/var/lib/kafka/logdir1"
                "/var/lib/kafka/logdir2"
              ];
            };
          })
          (mkIf (mode == "zookeeper") {
            settings = {
              "zookeeper.session.timeout.ms" = 600000;
              "zookeeper.connect" = [ "zookeeper1:2181" ];
            };
          })
          (mkIf (mode == "kraft") {
            clusterId = "ak2fIHr4S8WWarOF_ODD0g";
            formatLogDirs = true;
            settings = {
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
          })
        ];

        networking.firewall.allowedTCPPorts = [ 9092 9093 ];
        # i686 tests: qemu-system-i386 can simulate max 2047MB RAM (not 2048)
        virtualisation.memorySize = 2047;
      };
    } // optionalAttrs (mode == "zookeeper") {
      zookeeper1 = { ... }: {
        services.zookeeper = {
          enable = true;
        };

        networking.firewall.allowedTCPPorts = [ 2181 ];
      };
    };

    testScript = ''
      start_all()

      ${optionalString (mode == "zookeeper") ''
      zookeeper1.wait_for_unit("default.target")
      zookeeper1.wait_for_unit("zookeeper.service")
      zookeeper1.wait_for_open_port(2181)
      ''}

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
          + "--broker-list localhost:9092 --topic testtopic"
      )
      assert "test 1" in kafka.succeed(
          "${kafkaPackage}/bin/kafka-console-consumer.sh "
          + "--bootstrap-server localhost:9092 --topic testtopic "
          + "--from-beginning --max-messages 1"
      )
    '';
  }) { inherit system; });

in with pkgs; {
  kafka_3_6 = makeKafkaTest "kafka_3_6" { kafkaPackage = apacheKafka_3_6; };
  kafka_3_7 = makeKafkaTest "kafka_3_7" { kafkaPackage = apacheKafka_3_7; };
  kafka_3_8 = makeKafkaTest "kafka_3_8" { kafkaPackage = apacheKafka_3_8; };
  kafka = makeKafkaTest "kafka" { kafkaPackage = apacheKafka; };
  kafka_kraft = makeKafkaTest "kafka_kraft" { kafkaPackage = apacheKafka; mode = "kraft"; };
}
