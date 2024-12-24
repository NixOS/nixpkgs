{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.grafana_reporter;

in
{
  options.services.grafana_reporter = {
    enable = lib.mkEnableOption "grafana_reporter";

    grafana = {
      protocol = lib.mkOption {
        description = "Grafana protocol.";
        default = "http";
        type = lib.types.enum [
          "http"
          "https"
        ];
      };
      addr = lib.mkOption {
        description = "Grafana address.";
        default = "127.0.0.1";
        type = lib.types.str;
      };
      port = lib.mkOption {
        description = "Grafana port.";
        default = 3000;
        type = lib.types.port;
      };

    };
    addr = lib.mkOption {
      description = "Listening address.";
      default = "127.0.0.1";
      type = lib.types.str;
    };

    port = lib.mkOption {
      description = "Listening port.";
      default = 8686;
      type = lib.types.port;
    };

    templateDir = lib.mkOption {
      description = "Optional template directory to use custom tex templates";
      default = pkgs.grafana_reporter;
      defaultText = lib.literalExpression "pkgs.grafana_reporter";
      type = lib.types.either lib.types.str lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.grafana_reporter = {
      description = "Grafana Reporter Service Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig =
        let
          args = lib.concatStringsSep " " [
            "-proto ${cfg.grafana.protocol}://"
            "-ip ${cfg.grafana.addr}:${toString cfg.grafana.port}"
            "-port :${toString cfg.port}"
            "-templates ${cfg.templateDir}"
          ];
        in
        {
          ExecStart = "${pkgs.grafana-reporter}/bin/grafana-reporter ${args}";
        };
    };
  };
}
