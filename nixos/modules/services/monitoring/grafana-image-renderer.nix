{ lib, pkgs, config, ... }:

with lib;

let
  cfg = config.services.grafana-image-renderer;

  format = pkgs.formats.json { };

  configFile = format.generate "grafana-image-renderer-config.json" cfg.settings;
in {
  options.services.grafana-image-renderer = {
    enable = mkEnableOption "grafana-image-renderer";

    chromium = mkOption {
      type = types.package;
      description = ''
        The chromium to use for image rendering.
      '';
    };

    verbose = mkEnableOption "verbosity for the service";

    provisionGrafana = mkEnableOption "Grafana configuration for grafana-image-renderer";

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;

        options = {
          service = {
            port = mkOption {
              type = types.port;
              default = 8081;
              description = ''
                The TCP port to use for the rendering server.
              '';
            };
            logging.level = mkOption {
              type = types.enum [ "error" "warning" "info" "debug" ];
              default = "info";
              description = ''
                The log-level of the <filename>grafana-image-renderer.service</filename>-unit.
              '';
            };
          };
          rendering = {
            width = mkOption {
              default = 1000;
              type = types.ints.positive;
              description = ''
                Width of the PNG used to display the alerting graph.
              '';
            };
            height = mkOption {
              default = 500;
              type = types.ints.positive;
              description = ''
                Height of the PNG used to display the alerting graph.
              '';
            };
            mode = mkOption {
              default = "default";
              type = types.enum [ "default" "reusable" "clustered" ];
              description = ''
                Rendering mode of <package>grafana-image-renderer</package>:
                <itemizedlist>
                <listitem><para><literal>default:</literal> Creates on browser-instance
                  per rendering request.</para></listitem>
                <listitem><para><literal>reusable:</literal> One browser instance
                  will be started and reused for each rendering request.</para></listitem>
                <listitem><para><literal>clustered:</literal> allows to precisely
                  configure how many browser-instances are supposed to be used. The values
                  for that mode can be declared in <literal>rendering.clustering</literal>.
                  </para></listitem>
                </itemizedlist>
              '';
            };
            args = mkOption {
              type = types.listOf types.str;
              default = [ "--no-sandbox" ];
              description = ''
                List of CLI flags passed to <package>chromium</package>.
              '';
            };
          };
        };
      };

      default = {};

      description = ''
        Configuration attributes for <package>grafana-image-renderer</package>.

        See <link xlink:href="https://github.com/grafana/grafana-image-renderer/blob/ce1f81438e5f69c7fd7c73ce08bab624c4c92e25/default.json" />
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

    services.grafana.extraOptions = mkIf cfg.provisionGrafana {
      RENDERING_SERVER_URL = "http://localhost:${toString cfg.settings.service.port}/render";
      RENDERING_CALLBACK_URL = "http://localhost:${toString config.services.grafana.port}";
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
