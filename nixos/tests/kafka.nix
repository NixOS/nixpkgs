{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let
  makeKafkaTest = name: kafkaPackage: (makeTest {
    inherit name;
    meta = with pkgs.stdenv.lib.maintainers; {
      maintainers = [ nequissimus ];
    };

    nodes = {
      zookeeper1 = { ... }: {
        services.zookeeper = {
          enable = true;
        };

        networking.firewall.allowedTCPPorts = [ 2181 ];
        virtualisation.memorySize = 1024;
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
          # These are the default options, but UseCompressedOops doesn't work with 32bit JVM
          jvmOptions = [
            "-server" "-Xmx1G" "-Xms1G" "-XX:+UseParNewGC" "-XX:+UseConcMarkSweepGC" "-XX:+CMSClassUnloadingEnabled"
            "-XX:+CMSScavengeBeforeRemark" "-XX:+DisableExplicitGC" "-Djava.awt.headless=true" "-Djava.net.preferIPv4Stack=true"
          ] ++ optionals (! pkgs.stdenv.isi686 ) [ "-XX:+UseCompressedOops" ];
        };

        networking.firewall.allowedTCPPorts = [ 9092 ];
        # i686 tests: qemu-system-i386 can simulate max 2047MB RAM (not 2048)
        virtualisation.memorySize = 2047;
      };
    };

    testScript = ''
      startAll;

      $zookeeper1->waitForUnit("default.target");
      $zookeeper1->waitForUnit("zookeeper.service");
      $zookeeper1->waitForOpenPort(2181);

      $kafka->waitForUnit("default.target");
      $kafka->waitForUnit("apache-kafka.service");
      $kafka->waitForOpenPort(9092);

      $kafka->waitUntilSucceeds("${kafkaPackage}/bin/kafka-topics.sh --create --zookeeper zookeeper1:2181 --partitions 1 --replication-factor 1 --topic testtopic");
      $kafka->mustSucceed("echo 'test 1' | ${kafkaPackage}/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic testtopic");
    '' + (if name == "kafka_0_9" then ''
      $kafka->mustSucceed("${kafkaPackage}/bin/kafka-console-consumer.sh --zookeeper zookeeper1:2181 --topic testtopic --from-beginning --max-messages 1 | grep 'test 1'");
    '' else ''
      $kafka->mustSucceed("${kafkaPackage}/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic testtopic --from-beginning --max-messages 1 | grep 'test 1'");
    '');
  });

in with pkgs; {
  kafka_0_9  = makeKafkaTest "kafka_0_9"  apacheKafka_0_9;
  kafka_0_10 = makeKafkaTest "kafka_0_10" apacheKafka_0_10;
  kafka_0_11 = makeKafkaTest "kafka_0_11" apacheKafka_0_11;
  kafka_1_0  = makeKafkaTest "kafka_1_0"  apacheKafka_1_0;
  kafka_1_1  = makeKafkaTest "kafka_1_1"  apacheKafka_1_1;
  kafka_2_0  = makeKafkaTest "kafka_2_0"  apacheKafka_2_0;
  kafka_2_1  = makeKafkaTest "kafka_2_1"  apacheKafka_2_1;
}
