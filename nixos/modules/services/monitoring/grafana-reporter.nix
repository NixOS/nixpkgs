{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.grafana_reporter;

in
{
  options.services.grafana_reporter = {
    enable = mkEnableOption "grafana_reporter";

    grafana = {
      protocol = mkOption {
        description = "Grafana protocol.";
        default = "http";
        type = types.enum [
          "http"
          "https"
        ];
      };
      addr = mkOption {
        description = "Grafana address.";
        default = "127.0.0.1";
        type = types.str;
      };
      port = mkOption {
        description = "Grafana port.";
        default = 3000;
        type = types.port;
      };

    };
    addr = mkOption {
      description = "Listening address.";
      default = "127.0.0.1";
      type = types.str;
    };

    port = mkOption {
      description = "Listening port.";
      default = 8686;
      type = types.port;
    };

    templateDir = mkOption {
      description = "Optional template directory to use custom tex templates";
      default = pkgs.grafana_reporter;
      defaultText = literalExpression "pkgs.grafana_reporter";
      type = types.either types.str types.path;
    };
  };

  config = mkIf cfg.enable {
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
