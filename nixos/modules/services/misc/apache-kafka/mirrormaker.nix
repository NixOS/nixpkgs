{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.apache-kafka.mirrormaker;
  mirrormakerOpts = { name, ... }:
    {
      options = with types; {
        package = mkOption {
          type = package;
          default = pkgs.apacheKafka;
          description = "kafka package this instance refers to";
        };

        topics = mkOption {
          type = listOf str;
          description = "topics this mirrormaker instance will mirror";
        };

        heapOpts = mkOption {
          type = str;
          description = "heap options to pass to java";
          default = "";
        };

        streams = mkOption {
          type = int;
          description = "number of consumer threads";
          default = 1;
        };

        consumer = {
          bootstrapServers = mkOption {
            type = str;
            description = "[`bootstrap.servers`](https://jaceklaskowski.gitbooks.io/apache-kafka/content/kafka-properties-bootstrap-servers.html?q=group.id) is a comma-separated list of host and port pairs that are the addresses of the Kafka brokers in a \" bootstrap \" Kafka cluster that a Kafka client connects to initially to bootstrap itself.";
          };

          groupId = mkOption {
            type = str;
            description = "[`group.id`](https://jaceklaskowski.gitbooks.io/apache-kafka/content/kafka-properties-group-id.html) is the name of the consumer group a Kafka consumer belongs to.";
          };

          extraConfig = mkOption {
            type = str;
            description = "extra config options to add to `consumer.properties` .";
            default = "";
          };
        };

        producer = {

          bootstrapServers = mkOption {
            type = str;
            description = "[`bootstrap.servers`](https://jaceklaskowski.gitbooks.io/apache-kafka/content/kafka-properties-bootstrap-servers.html?q=group.id) is a comma-separated list of host and port pairs that are the addresses of the Kafka brokers in a \" bootstrap \" Kafka cluster that a Kafka client connects to initially to bootstrap itself.";
          };

          extraConfig = mkOption {
            type = str;
            description = "extra config options to add to `producer.properties` .";
            default = "";
          };

        };
      };
    };
in
{
  options.services.apache-kafka.mirrormaker = with types;  {

    enable = mkEnableOption "mirrormaker";

    instances = mkOption {
      type = attrsOf (submodule mirrormakerOpts);
      default = null;
      description = "attrset of instances of mirrormaker to run, with their individual specifications.";
    };
  };

  config.systemd = mkIf cfg.enable {
    targets.mirrormaker = {
      description = "Apache Kafka Mirrormaker instance target";
      wantedBy = [ "multi-user.target" ];
    };

    services = mapAttrs'
      (mm: mmOpts:
        nameValuePair "mirrormaker-${mm}" {
          description = "Apache Kafka Mirrormaker service for instance ${mm}";
          after = [ "network.target" ];
          wantedBy = [ "mirrormaker.target" ];
          partOf = [ "mirrormaker.target" ];
          environment = {
            KAFKA_HEAP_OPTS = mmOpts.heapOpts;
          };
          serviceConfig =
            let
              consumerProperties = pkgs.writeText "consumer.properties" ''
                bootstrap.servers = ${mmOpts.consumer.bootstrapServers}
                group.id = ${mmOpts.consumer.groupId}
                ${mmOpts.consumer.extraConfig}
              '';
              producerProperties = pkgs.writeText "producer.properties" ''
                bootstrap.servers = ${mmOpts.producer.bootstrapServers}
                ${mmOpts.producer.extraConfig}
              '';
            in
            {
              ExecStart = ''${mmOpts.package}/bin/kafka-mirror-maker.sh \
            --consumer.config ${consumerProperties} --producer.config ${producerProperties} --num.streams ${toString mmOpts.streams} \
            ${foldr (topic: sofar: " --whitelist=" + topic + sofar) "" mmOpts.topics} \
            '';
            };
        })
      cfg.instances;
  };
}

