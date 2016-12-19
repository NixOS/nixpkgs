{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.nodeExporter;
  cmdlineArgs = cfg.extraFlags ++ [
    "-web.listen-address=${cfg.listenAddress}"
  ];
in {
  options = {
    services.prometheus.nodeExporter = {
      enable = mkEnableOption "prometheus node exporter";

      port = mkOption {
        type = types.int;
        default = 9100;
        description = ''
          Port to listen on.
        '';
      };

      listenAddress = mkOption {
        type = types.string;
        default = "0.0.0.0";
        description = ''
          Address to listen on.
        '';
      };

      enabledCollectors = mkOption {
        type = types.listOf types.string;
        default = [];
        example = ''[ "systemd" ]'';
        description = ''
          Collectors to enable, additionally to the defaults.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the node exporter.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.prometheus-node-exporter = {
      description = "Prometheus exporter for machine metrics";
      unitConfig.Documentation = "https://github.com/prometheus/node_exporter";
      wantedBy = [ "multi-user.target" ];
      script = ''
        exec ${pkgs.prometheus-node-exporter}/bin/node_exporter \
          ${optionalString (cfg.enabledCollectors != [])
            ''-collectors.enabled ${concatStringsSep "," cfg.enabledCollectors}''} \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      serviceConfig = {
        User = "nobody";
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
