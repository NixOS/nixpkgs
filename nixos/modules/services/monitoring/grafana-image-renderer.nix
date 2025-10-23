{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.grafana-image-renderer;

  format = pkgs.formats.json { };

  configFile = format.generate "grafana-image-renderer-config.json" cfg.settings;
in
{
  options.services.grafana-image-renderer = {
    enable = lib.mkEnableOption "grafana-image-renderer";

    chromium = lib.mkOption {
      type = lib.types.package;
      description = ''
        The chromium to use for image rendering.
      '';
    };

    verbose = lib.mkEnableOption "verbosity for the service";

    provisionGrafana = lib.mkEnableOption "Grafana configuration for grafana-image-renderer";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          service = {
            port = lib.mkOption {
              type = lib.types.port;
              default = 8081;
              description = ''
                The TCP port to use for the rendering server.
              '';
            };
            logging.level = lib.mkOption {
              type = lib.types.enum [
                "error"
                "warning"
                "info"
                "debug"
              ];
              default = "info";
              description = ''
                The log-level of the {file}`grafana-image-renderer.service`-unit.
              '';
            };
          };
          rendering = {
            width = lib.mkOption {
              default = 1000;
              type = lib.types.ints.positive;
              description = ''
                Width of the PNG used to display the alerting graph.
              '';
            };
            height = lib.mkOption {
              default = 500;
              type = lib.types.ints.positive;
              description = ''
                Height of the PNG used to display the alerting graph.
              '';
            };
            mode = lib.mkOption {
              default = "default";
              type = lib.types.enum [
                "default"
                "reusable"
                "clustered"
              ];
              description = ''
                Rendering mode of `grafana-image-renderer`:

                - `default:` Creates on browser-instance
                  per rendering request.
                - `reusable:` One browser instance
                  will be started and reused for each rendering request.
                - `clustered:` allows to precisely
                  configure how many browser-instances are supposed to be used. The values
                  for that mode can be declared in `rendering.clustering`.
              '';
            };
            args = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "--no-sandbox" ];
              description = ''
                List of CLI flags passed to `chromium`.
              '';
            };
          };
        };
      };

      default = { };

      description = ''
        Configuration attributes for `grafana-image-renderer`.

        See <https://github.com/grafana/grafana-image-renderer/blob/ce1f81438e5f69c7fd7c73ce08bab624c4c92e25/default.json>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.provisionGrafana -> config.services.grafana.enable;
        message = ''
          To provision a Grafana instance to use grafana-image-renderer,
          `services.grafana.enable` must be set to `true`!
        '';
      }
    ];

    services.grafana.settings.rendering = lib.mkIf cfg.provisionGrafana {
      server_url = "http://localhost:${toString cfg.settings.service.port}/render";
      callback_url = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
    };

    services.grafana-image-renderer.chromium = lib.mkDefault pkgs.chromium;

    services.grafana-image-renderer.settings = {
      rendering = lib.mapAttrs (lib.const lib.mkDefault) {
        chromeBin = "${cfg.chromium}/bin/chromium";
        verboseLogging = cfg.verbose;
        timezone = config.time.timeZone;
      };

      service = {
        logging.level = lib.mkIf cfg.verbose (lib.mkDefault "debug");
        metrics.enabled = lib.mkDefault false;
      };
    };

    systemd.services.grafana-image-renderer = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";

      environment = {
        PUPPETEER_SKIP_CHROMIUM_DOWNLOAD = "true";
      };

      serviceConfig = {
        DynamicUser = true;
        PrivateTmp = true;
        ExecStart = "${pkgs.grafana-image-renderer}/bin/grafana-image-renderer server --config=${configFile}";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ma27 ];
}
