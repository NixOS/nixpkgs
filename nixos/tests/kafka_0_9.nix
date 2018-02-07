import ./make-test.nix ({ pkgs, lib, ... } :
let
  kafkaPackage = pkgs.apacheKafka_0_9;
in {
  name = "kafka_0_9";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ nequissimus ];
  };

  nodes = {
    zookeeper1 = { config, ... }: {
      services.zookeeper = {
        enable = true;
      };

      networking.firewall.allowedTCPPorts = [ 2181 ];
    };
    kafka = { config, ... }: {
      services.apache-kafka = {
        enable = true;
        extraProperties = ''
          offsets.topic.replication.factor = 1
        '';
        package = kafkaPackage;
        zookeeper = "zookeeper1:2181";
      };

      networking.firewall.allowedTCPPorts = [ 9092 ];
      virtualisation.memorySize = 2048;
    };
  };

  testScript = ''
    startAll;

    $zookeeper1->waitForUnit("zookeeper");
    $zookeeper1->waitForUnit("network.target");
    $zookeeper1->waitForOpenPort(2181);

    $kafka->waitForUnit("apache-kafka");
    $kafka->waitForUnit("network.target");
    $kafka->waitForOpenPort(9092);

    $kafka->waitUntilSucceeds("${kafkaPackage}/bin/kafka-topics.sh --create --zookeeper zookeeper1:2181 --partitions 1 --replication-factor 1 --topic testtopic");
    $kafka->mustSucceed("echo 'test 1' | ${kafkaPackage}/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic testtopic");
    $kafka->mustSucceed("${kafkaPackage}/bin/kafka-console-consumer.sh --zookeeper zookeeper1:2181 --topic testtopic --from-beginning --max-messages 1 | grep 'test 1'");
  '';
})
