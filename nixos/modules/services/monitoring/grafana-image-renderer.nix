{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.grafana-image-renderer;

  format = pkgs.formats.json { };

  configFile = format.generate "grafana-image-renderer-config.json" cfg.settings;
in {
  options.services.grafana-image-renderer = {
    enable = mkEnableOption (lib.mdDoc "grafana-image-renderer");

    chromium = mkOption {
      type = types.package;
      description = lib.mdDoc ''
        The chromium to use for image rendering.
      '';
    };

    verbose = mkEnableOption (lib.mdDoc "verbosity for the service");

    provisionGrafana = mkEnableOption (lib.mdDoc "Grafana configuration for grafana-image-renderer");

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options = {
          service = {
            port = mkOption {
              type = types.port;
              default = 8081;
              description = lib.mdDoc ''
                The TCP port to use for the rendering server.
              '';
            };
            logging.level = mkOption {
              type = types.enum [ "error" "warning" "info" "debug" ];
              default = "info";
              description = lib.mdDoc ''
                The log-level of the {file}`grafana-image-renderer.service`-unit.
              '';
            };
          };
          rendering = {
            width = mkOption {
              default = 1000;
              type = types.ints.positive;
              description = lib.mdDoc ''
                Width of the PNG used to display the alerting graph.
              '';
            };
            height = mkOption {
              default = 500;
              type = types.ints.positive;
              description = lib.mdDoc ''
                Height of the PNG used to display the alerting graph.
              '';
            };
            mode = mkOption {
              default = "default";
              type = types.enum [ "default" "reusable" "clustered" ];
              description = lib.mdDoc ''
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
            args = mkOption {
              type = types.listOf types.str;
              default = [ "--no-sandbox" ];
              description = lib.mdDoc ''
                List of CLI flags passed to `chromium`.
              '';
            };
          };
        };
      };

      default = {};

      description = lib.mdDoc ''
        Configuration attributes for `grafana-image-renderer`.

        See <https://github.com/grafana/grafana-image-renderer/blob/ce1f81438e5f69c7fd7c73ce08bab624c4c92e25/default.json>
        for supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.provisionGrafana -> config.services.grafana.enable;
        message = ''
          To provision a Grafana instance to use grafana-image-renderer,
          `services.grafana.enable` must be set to `true`!
        '';
      }
    ];

    services.grafana.settings.rendering = mkIf cfg.provisionGrafana {
      server_url = "http://localhost:${toString cfg.settings.service.port}/render";
      callback_url = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
    };

    services.grafana-image-renderer.chromium = mkDefault pkgs.chromium;

    services.grafana-image-renderer.settings = {
      rendering = mapAttrs (const mkDefault) {
        chromeBin = "${cfg.chromium}/bin/chromium";
        verboseLogging = cfg.verbose;
        timezone = config.time.timeZone;
      };

      service = {
        logging.level = mkIf cfg.verbose (mkDefault "debug");
        metrics.enabled = mkDefault false;
      };
    };

    systemd.services.grafana-image-renderer = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = " A Grafana backend plugin that handles rendering of panels & dashboards to PNGs using headless browser (Chromium/Chrome)";

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

  meta.maintainers = with maintainers; [ ma27 ];
}
