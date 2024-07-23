{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

import ./make-test-python.nix {
  name = "prometheus-kafka-adapter";

  nodes.n = { connfig, lib, ... }: {
    services = {
      apache-kafka = {
        enable = true;
        settings = {
          "log.dirs" = [
            "/var/lib/kafka/logdir1"
            "/var/lib/kafka/logdir2"
          ];
          "offsets.topic.replication.factor" = 1;
          "zookeeper.connect" = [ "localhost:2181" ];
          "zookeeper.session.timeout.ms" = 600000;
        };
      };
      zookeeper.enable = true;
      prometheus-kafka-adapter = {
        enable = true;
        brokers = [ "localhost" ];
        topic = "testtopic";
        # zookeeper binds 8080
        port = 8081;
      };
      prometheus = {
        enable = true;
        remoteWrite = [ {url = "http://localhost:8081/receive";} ];
        scrapeConfigs = lib.singleton {
          job_name = "prometheus";
          static_configs = lib.singleton {
            targets = [ "localhost:9090" ];
          };
        };
      };
    };
  };
  testScript = let
    kafkaPackage = pkgs.apacheKafka;
  in ''
    start_all()

    n.wait_for_unit("zookeeper.service")
    n.wait_for_open_port(2181)

    n.wait_for_unit("apache-kafka.service")
    n.wait_for_open_port(9092)

    n.wait_until_succeeds(
      "${kafkaPackage}/bin/kafka-topics.sh --create "
      + "--bootstrap-server localhost:9092 --partitions 1 "
      + "--replication-factor 1 --topic testtopic"
    )

    assert '"job":"prometheus"' in n.succeed(
      "${kafkaPackage}/bin/kafka-console-consumer.sh "
      + "--bootstrap-server localhost:9092 --topic testtopic "
      + "--from-beginning --max-messages 1"
    )
  '';
}
