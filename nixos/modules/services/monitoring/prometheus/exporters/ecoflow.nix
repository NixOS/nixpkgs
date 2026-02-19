{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.prometheus.exporters.ecoflow;
  inherit (lib) mkOption types;
in
{
  port = 2112;
  extraOpts = {
    exporterType = mkOption {
      type = types.enum [
        "rest"
        "mqtt"
      ];
      default = "rest";
      example = "mqtt";
      description = ''
        The type of exporter you'd like to use.
        Possible values: "rest" and "mqtt". Default value is "rest".
        Choose "rest" for the ecoflow online cloud api use "rest" and define: accessKey, secretKey.
        Choose "mqtt" for the lan realtime integration use "mqtt" and define: email, password, devices.
      '';
    };
    ecoflowAccessKeyFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-access-key;
      description = ''
        Path to the file with your personal api access string from the Ecoflow development website <https://developer-eu.ecoflow.com>.
        Do to share or commit your plaintext scecrets to a public repo use: agenix or soaps.
      '';
    };
    ecoflowSecretKeyFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-secret-key;
      description = ''
        Path to the file with your personal api secret string from the Ecoflow development website <https://developer-eu.ecoflow.com>.
        Do to share or commit your plaintext scecrets to a public repo use: agenix or soaps.
      '';
    };
    ecoflowEmailFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-email;
      description = ''
        Path to the file with your personal ecoflow app login email address.
        Do to share or commit your plaintext scecrets to a public repo use: agenix or soaps.
      '';
    };
    ecoflowPasswordFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-password;
      description = ''
        Path to the file with your personal ecoflow app login email password.
        Do to share or commit your plaintext passwords to a public repo use: agenix or soaps here!
      '';
    };
    ecoflowDevicesFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-devices;
      description = ''
        File must contain one line, example: R3300000,R3400000,NC430000,....
        The list of devices serial numbers separated by comma. For instance: SN1,SN2,SN3.
        Instead of "devicesFile" you can specify "devicesPrettynamesFile" which will also work. You can specify both.
        Do to share or commit your plaintext serial numbers to a public repo use: agenix or soaps.
      '';
    };
    ecoflowDevicesPrettyNamesFile = mkOption {
      type = types.path;
      default = /etc/ecoflow-devices-pretty-names;
      description = ''
        File must contain one line, example: {"R3300000":"Delta 2","R3400000":"Delta Pro",...}
        The key/value map of custom names for your devices. Key is a serial number, value is a device name you want
        to see in Grafana Dashboard. It's helpful to see a meaningful name in Grafana dashboard instead of a serialnumber.
        Do to share or commit your plaintext serial numbers to a public repo use: agenix or soaps.
      '';
    };
    debug = mkOption {
      type = types.str;
      default = "0";
      example = "1";
      description = ''
        Enable debug log messages. Disabled by default. Set to "1" to enable.
      '';
    };
    prefix = mkOption {
      type = types.str;
      default = "ecoflow";
      example = "ecoflow_privateSite";
      description = ''
        The prefix that will be added to all metrics. Default value is ecoflow.
        For instance metric bms_bmsStatus.minCellTemp will be exported to prometheus as ecoflow.bms_bmsStatus.minCellTemp.
        With default value "ecoflow" you can use Grafana Dashboard with ID 17812 without any changes.
      '';
    };
    scrapingInterval = mkOption {
      type = types.ints.positive;
      default = 30;
      example = 120;
      description = ''
        Scrapping interval in seconds. How often should the exporter execute requests to Ecoflow Rest API in order to get the data.
        Default value is 30 seconds. Align this value with your prometheus scraper interval settings.
      '';
    };
    mqttDeviceOfflineThreshold = mkOption {
      type = types.ints.positive;
      default = 60;
      example = 120;
      description = ''
        The threshold in seconds which indicates how long we should wait for a metric message from MQTT broker.
        Default value: 60 seconds. If we don't receive message within 60 seconds we consider that device is offline.
        If we don't receive messages within the threshold for all devices, we'll try to reconnect to the MQTT broker.
        There is a strange behavior that MQTT stop sends messages if you open Ecoflow mobile app and then close it).
      '';
    };
  };
  serviceOpts = {
    environment = {
      PROMETHEUS_ENABLED = "1";
      EXPORTER_TYPE = cfg.exporterType;
      DEBUG_ENABLED = cfg.debug;
      METRIC_PREFIX = cfg.prefix;
      SCRAPING_INTERVAL = toString cfg.scrapingInterval;
      MQTT_DEVICE_OFFLINE_THRESHOLD_SECONDS = toString cfg.mqttDeviceOfflineThreshold;
    };
    script = ''
      export ECOFLOW_ACCESS_KEY="$(cat ${toString cfg.ecoflowAccessKeyFile})"
      export ECOFLOW_SECRET_KEY="$(cat ${toString cfg.ecoflowSecretKeyFile})"
      export ECOFLOW_EMAIL="$(cat ${toString cfg.ecoflowEmailFile})"
      export ECOFLOW_PASSWORD="$(cat ${toString cfg.ecoflowPasswordFile})"
      export ECOFLOW_DEVICES="$(cat ${toString cfg.ecoflowDevicesFile})"
      export ECOFLOW_DEVICES_PRETTY_NAMES="$(cat ${toString cfg.ecoflowDevicesPrettyNamesFile})"
      exec ${lib.getExe pkgs.go-ecoflow-exporter}'';
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      Restart = "on-failure";
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
      ];
      RestrictNamespaces = true;
      User = "prometheus"; # context needed to runtime access encrypted token and secrets
    };
  };
}
