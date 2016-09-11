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
      enable = mkEnableOption "Enable the Prometheus node exporter (CPU stats etc).";
      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0:9100";
        description = ''
          Address to listen on.
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
        ${concatStringsSep " \\\n  " cmdlineArgs}
      '';
      serviceConfig = {
        User = "nobody";
        Restart  = "always";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
