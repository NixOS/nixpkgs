{
  config,
  lib,
  pkgs,
  options,
  utils,
}:

let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.services.prometheus.exporters.mqtt;
  toConfigBoolean = x: if x then "True" else "False";
  toConfigList = builtins.concatStringsSep ",";
in
{
  # https://github.com/kpetremann/mqtt-exporter/tree/master?tab=readme-ov-file#configuration
  port = 9000;
  extraOpts = {
    keepFullTopic = mkEnableOption "Keep entire topic instead of the first two elements only. Usecase: Shelly 3EM";
    logLevel = mkOption {
      type = types.enum [
        "CRITICAL"
        "ERROR"
        "WARNING"
        "INFO"
        "DEBUG"
      ];
      default = "INFO";
      example = "DEBUG";
      description = "Logging level";
    };
    logMqttMessage = mkEnableOption "Log MQTT original message, only if `LOG_LEVEL` is set to DEBUG.";
    mqttIgnoredTopics = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Lists of topics to ignore. Accepts wildcards.";
    };
    mqttAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP or hostname of MQTT broker.";
    };
    mqttPort = mkOption {
      type = types.port;
      default = 1883;
      description = "TCP port of MQTT broker.";
    };
    mqttTopic = mkOption {
      type = types.str;
      default = "#";
      description = "Topic path to subscribe to.";
    };
    mqttKeepAlive = mkOption {
      type = types.int;
      default = 60;
      example = 30;
      description = "Keep alive interval to maintain connection with MQTT broker.";
    };
    mqttUsername = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "mqttexporter";
      description = "Username which should be used to authenticate against the MQTT broker.";
    };
    mqttV5Protocol = mkEnableOption "Force to use MQTT protocol v5 instead of 3.1.1.";
    mqttClientId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Set client ID manually for MQTT connection";
    };
    mqttExposeClientId = mkEnableOption "Expose the client ID as a label in Prometheus metrics.";
    prometheusPrefix = mkOption {
      type = types.str;
      default = "mqtt_";
      description = "Prefix added to the metric name.";
    };
    topicLabel = mkOption {
      type = types.str;
      default = "topic";
      description = "Define the Prometheus label for the topic.";
    };
    zigbee2MqttAvailability = mkEnableOption "Normalize sensor name for device availability metric added by Zigbee2MQTT.";
    zwaveTopicPrefix = mkOption {
      type = types.str;
      default = "zwave/";
      description = "MQTT topic used for Zwavejs2Mqtt messages.";
    };
    esphomeTopicPrefixes = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "MQTT topic used for ESPHome messages.";
    };
    hubitatTopicPrefixes = mkOption {
      type = types.listOf types.str;
      default = [ "hubitat/" ];
      description = "MQTT topic used for Hubitat messages.";
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = [ "/run/secrets/mqtt-exporter" ];
      description = ''
        File to load as environment file. Useful for e.g. setting `MQTT_PASSWORD`
        without putting any secrets into the Nix store.
      '';
    };
  };
  serviceOpts = {
    environment = {
      KEEP_FULL_TOPIC = toConfigBoolean cfg.keepFullTopic;
      LOG_LEVEL = cfg.logLevel;
      LOG_MQTT_MESSAGE = toConfigBoolean cfg.logMqttMessage;
      MQTT_IGNORED_TOPIC = toConfigList cfg.mqttIgnoredTopics;
      MQTT_ADDRESS = cfg.mqttAddress;
      MQTT_PORT = toString cfg.mqttPort;
      MQTT_TOPIC = cfg.mqttTopic;
      MQTT_KEEPALIVE = toString cfg.mqttKeepAlive;
      MQTT_USERNAME = cfg.mqttUsername;
      MQTT_V5_PROTOCOL = toConfigBoolean cfg.mqttV5Protocol;
      MQTT_CLIENT_ID = mkIf (cfg.mqttClientId != null) cfg.mqttClientId;
      PROMETHEUS_ADDRESS = cfg.listenAddress;
      PROMETHEUS_PORT = toString cfg.port;
      PROMETHEUS_PREFIX = cfg.prometheusPrefix;
      TOPIC_LABEL = cfg.topicLabel;
      ZIGBEE2MQTT_AVAILABILITY = toConfigBoolean cfg.zigbee2MqttAvailability;
      ZWAVE_TOPIC_PREFIX = cfg.zwaveTopicPrefix;
      ESPHOME_TOPIC_PREFIXES = toConfigList cfg.esphomeTopicPrefixes;
      HUBITAT_TOPIC_PREFIXES = toConfigList cfg.hubitatTopicPrefixes;
    };
    serviceConfig = {
      EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
      ExecStart = lib.getExe pkgs.mqtt-exporter;
    };
  };
}
