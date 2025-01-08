{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.flow;
in
{
  port = 9590;
  extraOpts = {
    brokers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = lib.literalExpression ''[ "kafka.example.org:19092" ]'';
      description = "List of Kafka brokers to connect to.";
    };

    asn = lib.mkOption {
      type = lib.types.ints.positive;
      example = 65542;
      description = "The ASN being monitored.";
    };

    partitions = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = ''
        The number of the partitions to consume, none means all.
      '';
    };

    topic = lib.mkOption {
      type = lib.types.str;
      example = "pmacct.acct";
      description = "The Kafka topic to consume from.";
    };
  };

  serviceOpts = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-flow-exporter}/bin/flow-exporter \
          -asn ${toString cfg.asn} \
          -topic ${cfg.topic} \
          -brokers ${lib.concatStringsSep "," cfg.brokers} \
          ${lib.optionalString (cfg.partitions != [ ]) "-partitions ${lib.concatStringsSep "," cfg.partitions}"} \
          -addr ${cfg.listenAddress}:${toString cfg.port} ${lib.concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
