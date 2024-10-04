{ config, pkgs, lib, ... }:
let
  cfg = config.services.prometheus-kafka-adapter;
  inherit (lib) mkOption types mkPackageOption concatStringsSep mkIf mkEnableOption;
in {
  options.services.prometheus-kafka-adapter = with types; {
    enable = mkEnableOption "prometheus kafka adapter";
    package = mkPackageOption pkgs "prometheus-kafka-adapter" { };
    brokers = mkOption {
      type = listOf str;
      description = "List of kafka brokers";
      example = [ "kafka-1.internal" "kafka-2.internal" "kafka-3.internal" ];
    };
    topic = mkOption {
      type = str;
      description = "Kafka topic to write to";
      example = "cluster1.prometehus";
    };
    compression = mkOption {
      type = str;
      default = "none";
      description = "Compression type to be used, such as gzip, snappy, lz4";
      example = "zstd";
    };
    logLevel = mkOption {
      type = enum [ "debug" "info" "warn" "error" "fatal" "panic" ];
      default = "warn";
      description = "Log level for logrus";
    };
    port = mkOption {
      type = port;
      description = "Port to listen on";
      default = 8080;
    };
    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Whether to open the port in firewall";
    };
    extraEnvironment = mkOption {
      type = attrsOf str;
      description = "Additional environment variables to pass to prometheus kafka adapter";
      default = { };
      example = {
        SERIALIZATION_FORMAT = "json";
        GIN_MODE = "debug";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.prometheus-kafka-adapter = {
      wantedBy = [ "multi-user.target" ];
      script = lib.getExe cfg.package;
      environment = {
        GIN_MODE = "release";
        KAFKA_BROKER_LIST = concatStringsSep "," cfg.brokers;
        KAFKA_TOPIC = cfg.topic;
        KAFKA_COMPRESSION = cfg.compression;
        LOG_LEVEL = cfg.logLevel;
        PORT = toString cfg.port;
      } // cfg.extraEnvironment;
      serviceConfig = {
        User = "prom-kafka-adapter";
        DynamicUser = true;
      };
    };
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
