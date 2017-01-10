{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.jsonExporter;
in {
  options = {
    services.prometheus.jsonExporter = {
      enable = mkEnableOption "prometheus JSON exporter";

      url = mkOption {
        type = types.str;
        description = ''
          URL to scrape JSON from.
        '';
      };

      configFile = mkOption {
        type = types.path;
        description = ''
          Path to configuration file.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 7979;
        description = ''
          Port to listen on.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the JSON exporter.
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

    systemd.services.prometheus-json-exporter = {
      description = "Prometheus exporter for JSON over HTTP";
      unitConfig.Documentation = "https://github.com/kawamuray/prometheus-json-exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nobody";
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-json-exporter}/bin/prometheus-json-exporter \
            --port ${toString cfg.port} \
            ${cfg.url} ${cfg.configFile} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
