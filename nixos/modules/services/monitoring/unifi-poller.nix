{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.unifi-poller;

  controllerConfig = types.submodule {
    options = {
      role = mkOption {
        type = types.nullOr types.str;
        description = "Role allows grouping of controllers. By default grouping is done on the URL.";
        default = null;
      };
      url = mkOption {
        type = types.str;
        description = "URL of the Unifi controller.";
        example = "https://127.0.0.1:8443";
      };
      username = mkOption {
        type = types.str;
        description = "Username used to access the unifi controller. The user needs read access.";
        example = "unifipoller";
      };
      passwordFile = mkOption {
        description = "File that containts the password to access the unifi controller.";
        type = types.path;
      };
      verifySSL = mkOption {
        description = "Wheter to verify the TLS certificate of the unifi controller.";
        type = types.bool;
        default = false;
      };
    };
  };
  controllerToEnv = i: controller: (''
    # Controller ${toString i}
    export UP_UNIFI_CONTROLLER_${toString i}_URL="${controller.url}"
    export UP_UNIFI_CONTROLLER_${toString i}_USER="${controller.username}"
    export UP_UNIFI_CONTROLLER_${toString i}_PASS="$(cat ${escapeShellArg controller.passwordFile})"
    export UP_UNIFI_CONTROLLER_${toString i}_VERIFY_SSL="${if controller.verifySSL then "true" else "false"}"
  ''
  + lib.optionalString (controller.role != null) ''
    export UP_UNIFI_CONTROLLER_${toString i}_ROLE="${controller.role}"
  '');
  controllerEnvOptions = foldr (l: r: l + r) "" (imap0 controllerToEnv cfg.controllers);

  influxdbEnvOptions = optionalString (cfg.influxdb.url != null) ''
    # InfluxDB
    export UP_INFLUXDB_URL="${cfg.influxdb.url}"
    export UP_INFLUXDB_DB="${cfg.influxdb.db}"
    export UP_INFLUXDB_USER="${cfg.influxdb.username}"
    export UP_INFLUXDB_PASS="$(cat ${escapeShellArg cfg.influxdb.passwordFile})"
    export UP_INFLUXDB_INTERVAL="${cfg.influxdb.interval}"
  '';

  prometheusEnvOptions = ''
    # Prometheus
    export UP_PROMETHEUS_DISABLE="${if cfg.prometheus.enable then "false" else "true"}"
    export UP_PROMETHEUS_HTTP_LISTEN="${cfg.prometheus.httpListen}"
  '';

in {
  options = {
    services.unifi-poller = {
      enable = mkEnableOption "unifi-poller service";

      controllers = mkOption {
        description = "Unifi controller configuration";
        type = types.listOf controllerConfig;
      };

      prometheus = {
        enable = mkOption {
          description = "Enable the prometheus exporter.";
          type = types.bool;
          default = true;
        };

        httpListen = mkOption {
          description = "Address and port to listen for incomming prometheus requests.";
          type = types.str;
          default = "0.0.0.0:9130";
        };
      };

      influxdb = {
        url = mkOption {
          type = types.nullOr types.str;
          description = "URL of the influx database server.";
          example = "http://127.0.0.1:8086";
          default = null;
        };
        db = mkOption {
          type = types.str;
          description = "Name of influx database. Must already exist and be writable.";
          default = "unifi";
        };
        username = mkOption {
          type = types.str;
          description = "Username to access the influx database.";
        };
        passwordFile = mkOption {
          description = "File that containts the password to access the influx database.";
          type = types.path;
        };
        interval = mkOption {
          type = types.str;
          description = "How often to poll and collect metrics.";
          example = "1m";
          default = "30s";
        };
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.unifi-poller = {
      description = "Unifi poller service";
      wantedBy = ["multi-user.target"];
      after = ["networking.target"];
      script = ''
        ${prometheusEnvOptions}
        ${controllerEnvOptions}
        ${influxdbEnvOptions}

        # We configure unifi-poller via env variable, but it still tries to load a config file from /etc
        # so we pass /dev/null as config file which is sufficient as the content of the file is not used.
        exec ${pkgs.unifi-poller}/bin/unifi-poller -c /dev/null
      '';
      serviceConfig = {
        DynamicUser = true;
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ bachp ];
}
