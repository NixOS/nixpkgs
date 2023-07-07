{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with pkgs.lib;

let
  makeKafkaTest = name: kafkaPackage: (import ./make-test-python.nix ({
    inherit name;
    meta = with pkgs.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes = {
      zookeeper1 = { ... }: {
        services.zookeeper = {
          enable = true;
        };

        networking.firewall.allowedTCPPorts = [ 2181 ];
      };
      kafka = { ... }: {
        services.apache-kafka = {
          enable = true;
          extraProperties = ''
            offsets.topic.replication.factor = 1
            zookeeper.session.timeout.ms = 600000
          '';
          package = kafkaPackage;
          zookeeper = "zookeeper1:2181";
        };

        networking.firewall.allowedTCPPorts = [ 9092 ];
        # i686 tests: qemu-system-i386 can simulate max 2047MB RAM (not 2048)
        virtualisation.memorySize = 2047;
      };
    };

    testScript = ''
      start_all()

      zookeeper1.wait_for_unit("default.target")
      zookeeper1.wait_for_unit("zookeeper.service")
      zookeeper1.wait_for_open_port(2181)

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
  kafka_2_8  = makeKafkaTest "kafka_2_8"  apacheKafka_2_8;
  kafka_3_0  = makeKafkaTest "kafka_3_0"  apacheKafka_3_0;
  kafka_3_1  = makeKafkaTest "kafka_3_1"  apacheKafka_3_1;
  kafka_3_2  = makeKafkaTest "kafka_3_2"  apacheKafka_3_2;
  kafka_3_3  = makeKafkaTest "kafka_3_3"  apacheKafka_3_3;
  kafka_3_4  = makeKafkaTest "kafka_3_4"  apacheKafka_3_4;
  kafka_3_5  = makeKafkaTest "kafka_3_5"  apacheKafka_3_5;
  kafka  = makeKafkaTest "kafka"  apacheKafka;
}
