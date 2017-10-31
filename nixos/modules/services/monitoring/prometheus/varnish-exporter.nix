{ config, pkgs, lib, ... }:

# Shamelessly cribbed from nginx-exporter.nix. ~ C.
with lib;

let
  cfg = config.services.prometheus.varnishExporter;
in {
  options = {
    services.prometheus.varnishExporter = {
      enable = mkEnableOption "prometheus Varnish exporter";

      port = mkOption {
        type = types.int;
        default = 9131;
        description = ''
          Port to listen on.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the Varnish exporter.
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

    systemd.services.prometheus-varnish-exporter = {
      description = "Prometheus exporter for Varnish metrics";
      unitConfig.Documentation = "https://github.com/jonnenauha/prometheus_varnish_exporter";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.varnish ];
      script = ''
        exec ${pkgs.prometheus-varnish-exporter}/bin/prometheus_varnish_exporter \
          -web.listen-address :${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      serviceConfig = {
        User = "nobody";
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      };
    };
  };
}
