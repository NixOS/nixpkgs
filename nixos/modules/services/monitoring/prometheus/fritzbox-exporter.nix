{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.fritzboxExporter;
in {
  options = {
    services.prometheus.fritzboxExporter = {
      enable = mkEnableOption "prometheus fritzbox exporter";

      port = mkOption {
        type = types.int;
        default = 9133;
        description = ''
          Port to listen on.
        '';
      };

      gatewayAddress = mkOption {
        type = types.str;
        default = "fritz.box";
        description = ''
          The hostname or IP of the FRITZ!Box.
        '';
      };

      gatewayPort = mkOption {
        type = types.int;
        default = 49000;
        description = ''
          The port of the FRITZ!Box UPnP service.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the fritzbox exporter.
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

    systemd.services.prometheus-fritzbox-exporter = {
      description = "Prometheus exporter for FRITZ!Box via UPnP";
      unitConfig.Documentation = "https://github.com/ndecker/fritzbox_exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nobody";
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-fritzbox-exporter}/bin/fritzbox_exporter \
            -listen-address :${toString cfg.port} \
            -gateway-address ${cfg.gatewayAddress} \
            -gateway-port ${toString cfg.gatewayPort} \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
      };
    };
  };
}
