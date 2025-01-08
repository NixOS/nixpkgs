{ config, lib, pkgs, ... }:
let
  inherit (lib) maintainers;
  inherit (lib.meta) getExe;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.options) literalExpression mkEnableOption lib.mkOption mkPackageOption;
  inherit (lib.types) bool enum nullOr port str submodule;

  cfg = config.services.scrutiny;
  # Define the settings format used for this program
  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.scrutiny = {
      enable = lib.mkEnableOption "Scrutiny, a web application for drive monitoring";

      package = lib.mkPackageOption pkgs "scrutiny" { };

      openFirewall = mkEnableOption "opening the default ports in the firewall for Scrutiny";

      influxdb.enable = lib.mkOption {
        type = bool;
        default = true;
        description = ''
          Enables InfluxDB on the host system using the `services.influxdb2` NixOS module
          with default options.

          If you already have InfluxDB configured, or wish to connect to an external InfluxDB
          instance, disable this option.
        '';
      };

      settings = lib.mkOption {
        description = ''
          Scrutiny settings to be rendered into the configuration file.

          See https://github.com/AnalogJ/scrutiny/blob/master/example.scrutiny.yaml.
        '';
        default = { };
        type = submodule {
          freeformType = settingsFormat.type;

          options.web.listen.port = lib.mkOption {
            type = port;
            default = 8080;
            description = "Port for web application to listen on.";
          };

          options.web.listen.host = lib.mkOption {
            type = str;
            default = "0.0.0.0";
            description = "Interface address for web application to bind to.";
          };

          options.web.listen.basepath = lib.mkOption {
            type = str;
            default = "";
            example = "/scrutiny";
            description = ''
              If Scrutiny will be behind a path prefixed reverse proxy, you can override this
              value to serve Scrutiny on a subpath.
            '';
          };

          options.log.level = lib.mkOption {
            type = enum [ "INFO" "DEBUG" ];
            default = "INFO";
            description = "Log level for Scrutiny.";
          };

          options.web.influxdb.scheme = lib.mkOption {
            type = str;
            default = "http";
            description = "URL scheme to use when connecting to InfluxDB.";
          };

          options.web.influxdb.host = lib.mkOption {
            type = str;
            default = "0.0.0.0";
            description = "IP or hostname of the InfluxDB instance.";
          };

          options.web.influxdb.port = lib.mkOption {
            type = port;
            default = 8086;
            description = "The port of the InfluxDB instance.";
          };

          options.web.influxdb.tls.insecure_skip_verify = mkEnableOption "skipping TLS verification when connecting to InfluxDB";

          options.web.influxdb.token = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "Authentication token for connecting to InfluxDB.";
          };

          options.web.influxdb.org = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "InfluxDB organisation under which to store data.";
          };

          options.web.influxdb.bucket = lib.mkOption {
            type = nullOr str;
            default = null;
            description = "InfluxDB bucket in which to store data.";
          };
        };
      };

      collector = {
        enable = lib.mkEnableOption "the Scrutiny metrics collector" // {
          default = cfg.enable;
          defaultText = lib.literalExpression "config.services.scrutiny.enable";
        };

        package = lib.mkPackageOption pkgs "scrutiny-collector" { };

        schedule = lib.mkOption {
          type = str;
          default = "*:0/15";
          description = ''
            How often to run the collector in systemd calendar format.
          '';
        };

        settings = lib.mkOption {
          description = ''
            Collector settings to be rendered into the collector configuration file.

            See https://github.com/AnalogJ/scrutiny/blob/master/example.collector.yaml.
          '';
          default = { };
          type = submodule {
            freeformType = settingsFormat.type;

            options.host.id = lib.mkOption {
              type = nullOr str;
              default = null;
              description = "Host ID for identifying/labelling groups of disks";
            };

            options.api.endpoint = lib.mkOption {
              type = str;
              default = "http://${cfg.settings.web.listen.host}:${toString cfg.settings.web.listen.port}";
              defaultText = lib.literalExpression ''"http://''${config.services.scrutiny.settings.web.listen.host}:''${config.services.scrutiny.settings.web.listen.port}"'';
              description = "Scrutiny app API endpoint for sending metrics to.";
            };

            options.log.level = lib.mkOption {
              type = enum [ "INFO" "DEBUG" ];
              default = "INFO";
              description = "Log level for Scrutiny collector.";
            };
          };
        };
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.influxdb2.enable = cfg.influxdb.enable;

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.settings.web.listen.port ];
      };

      systemd.services.scrutiny = {
        description = "Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ] ++ lib.optional cfg.influxdb.enable "influxdb2.service";
        wants = lib.optional cfg.influxdb.enable "influxdb2.service";
        environment = {
          SCRUTINY_VERSION = "1";
          SCRUTINY_WEB_DATABASE_LOCATION = "/var/lib/scrutiny/scrutiny.db";
          SCRUTINY_WEB_SRC_FRONTEND_PATH = "${cfg.package}/share/scrutiny";
        };
        postStart = ''
          for i in $(seq 300); do
              if "${lib.getExe pkgs.curl}" --fail --silent --head "http://${cfg.settings.web.listen.host}:${toString cfg.settings.web.listen.port}" >/dev/null; then
                  echo "Scrutiny is ready (port is open)"
                  exit 0
              fi
              echo "Waiting for Scrutiny to open port..."
              sleep 0.2
          done
          echo "Timeout waiting for Scrutiny to open port" >&2
          exit 1
        '';
        serviceConfig = {
          DynamicUser = true;
          ExecStart = "${getExe cfg.package} start --config ${settingsFormat.generate "scrutiny.yaml" cfg.settings}";
          Restart = "always";
          StateDirectory = "scrutiny";
          StateDirectoryMode = "0750";
        };
      };
    })
    (lib.mkIf cfg.collector.enable {
      services.smartd = {
        enable = true;
        extraOptions = [
          "-A /var/log/smartd/"
          "--interval=600"
        ];
      };

      systemd = {
        services.scrutiny-collector = {
          description = "Scrutiny Collector Service";
          after = lib.optional cfg.enable "scrutiny.service";
          wants = lib.optional cfg.enable "scrutiny.service";
          environment = {
            COLLECTOR_VERSION = "1";
            COLLECTOR_API_ENDPOINT = cfg.collector.settings.api.endpoint;
          };
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${getExe cfg.collector.package} run --config ${settingsFormat.generate "scrutiny-collector.yaml" cfg.collector.settings}";
          };
          startAt = cfg.collector.schedule;
        };

        timers.scrutiny-collector.timerConfig.Persistent = true;
      };
    })
  ];

  meta.maintainers = [ lib.maintainers.jnsgruk ];
}
