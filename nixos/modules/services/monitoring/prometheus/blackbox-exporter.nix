{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.blackboxExporter;
in {
  options = {
    services.prometheus.blackboxExporter = {
      enable = mkEnableOption "prometheus blackbox exporter";

      configFile = mkOption {
        type = types.path;
        description = ''
          Path to configuration file.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 9115;
        description = ''
          Port to listen on.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the blackbox exporter.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open port in firewall for incoming connections.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;

    systemd.services.prometheus-blackbox-exporter = {
      description = "Prometheus exporter for blackbox probes";
      unitConfig.Documentation = "https://github.com/prometheus/blackbox_exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nobody";
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
        ExecStart = ''
          ${pkgs.prometheus-blackbox-exporter}/bin/blackbox_exporter \
            --web.listen-address :${toString cfg.port} \
            --config.file ${cfg.configFile} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
