{ config, lib, pkgs, ... }:
let
  cfg = config.services.scrutiny;
  # Define the settings format used for this program
  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.scrutiny = {
      enable = lib.mkEnableOption "Enables the scrutiny web application.";

      package = lib.mkPackageOptionMD pkgs "scrutiny" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the default ports in the firewall for Scrutiny.";
      };

      influxdb.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Enables InfluxDB on the host system using the `services.influxdb2` NixOS module
          with default options.

          If you already have InfluxDB configured, or wish to connect to an external InfluxDB
          instance, disable this option.
        '';
      };

      settings = lib.mkOption {
        description = lib.mdDoc ''
          Scrutiny settings to be rendered into the configuration file.

          See https://github.com/AnalogJ/scrutiny/blob/master/example.scrutiny.yaml.
        '';
        default = { };
        type = lib.types.submodule {
          freeformType = settingsFormat.type;

          options.web.listen.port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = lib.mdDoc "Port for web application to listen on.";
          };

          options.web.listen.host = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = lib.mdDoc "Interface address for web application to bind to.";
          };

          options.web.listen.basepath = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "/scrutiny";
            description = lib.mdDoc ''
              If Scrutiny will be behind a path prefixed reverse proxy, you can override this
              value to serve Scrutiny on a subpath.
            '';
          };

          options.log.level = lib.mkOption {
            type = lib.types.enum [ "INFO" "DEBUG" ];
            default = "INFO";
            description = lib.mdDoc "Log level for Scrutiny.";
          };

          options.web.influxdb.scheme = lib.mkOption {
            type = lib.types.str;
            default = "http";
            description = lib.mdDoc "URL scheme to use when connecting to InfluxDB.";
          };

          options.web.influxdb.host = lib.mkOption {
            type = lib.types.str;
            default = "0.0.0.0";
            description = lib.mdDoc "IP or hostname of the InfluxDB instance.";
          };

          options.web.influxdb.port = lib.mkOption {
            type = lib.types.port;
            default = 8086;
            description = lib.mdDoc "The port of the InfluxDB instance.";
          };

          options.web.influxdb.tls.insecure_skip_verify = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = lib.mdDoc "Skip TLS verification when connecting to InfluxDB.";
          };

          options.web.influxdb.token = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = lib.mdDoc "Authentication token for connecting to InfluxDB.";
          };

          options.web.influxdb.org = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = lib.mdDoc "InfluxDB organisation under which to store data.";
          };

          options.web.influxdb.bucket = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = lib.mdDoc "InfluxDB bucket in which to store data.";
          };
        };
      };

      collector = {
        enable = lib.mkEnableOption "Enables the scrutiny metrics collector.";

        package = lib.mkPackageOptionMD pkgs "scrutiny-collector" { };

        schedule = lib.mkOption {
          type = lib.types.str;
          default = "*:0/15";
          description = lib.mdDoc ''
            How often to run the collector in systemd calendar format.
          '';
        };

        settings = lib.mkOption {
          description = lib.mdDoc ''
            Collector settings to be rendered into the collector configuration file.

            See https://github.com/AnalogJ/scrutiny/blob/master/example.collector.yaml.
          '';
          default = { };
          type = lib.types.submodule {
            freeformType = settingsFormat.type;

            options.host.id = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = lib.mdDoc "Host ID for identifying/labelling groups of disks";
            };

            options.api.endpoint = lib.mkOption {
              type = lib.types.str;
              default = "http://localhost:8080";
              description = lib.mdDoc "Scrutiny app API endpoint for sending metrics to.";
            };

            options.log.level = lib.mkOption {
              type = lib.types.enum [ "INFO" "DEBUG" ];
              default = "INFO";
              description = lib.mdDoc "Log level for Scrutiny collector.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf (cfg.enable || cfg.collector.enable) {
    services.influxdb2.enable = cfg.influxdb.enable;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.web.listen.port ];
    };

    services.smartd = lib.mkIf cfg.collector.enable {
      enable = true;
      extraOptions = [
        "-A /var/log/smartd/"
        "--interval=600"
      ];
    };

    systemd = {
      services = {
        scrutiny = lib.mkIf cfg.enable {
          description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment = {
            SCRUTINY_VERSION = "1";
            SCRUTINY_WEB_DATABASE_LOCATION = "/var/lib/scrutiny/scrutiny.db";
            SCRUTINY_WEB_SRC_FRONTEND_PATH = "${cfg.package}/share/scrutiny";
          };
          serviceConfig = {
            DynamicUser = true;
            ExecStart = "${lib.getExe cfg.package} start --config ${settingsFormat.generate "scrutiny.yaml" cfg.settings}";
            Restart = "always";
            StateDirectory = "scrutiny";
            StateDirectoryMode = "0750";
          };
        };

        scrutiny-collector = lib.mkIf cfg.collector.enable {
          description = "Scrutiny Collector Service";
          environment = {
            COLLECTOR_VERSION = "1";
            COLLECTOR_API_ENDPOINT = cfg.collector.settings.api.endpoint;
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${lib.getExe cfg.collector.package} run --config ${settingsFormat.generate "scrutiny-collector.yaml" cfg.collector.settings}";
          };
        };
      };

      timers = lib.mkIf cfg.collector.enable {
        scrutiny-collector = {
          timerConfig = {
            OnCalendar = cfg.collector.schedule;
            Persistent = true;
            Unit = "scrutiny-collector.service";
          };
        };
      };
    };
  };

  meta.maintainers = [ lib.maintainers.jnsgruk ];
}
