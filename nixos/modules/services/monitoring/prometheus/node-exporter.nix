{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.nodeExporter;
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
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    systemd.services.prometheus-node-exporter = {
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      script = ''
        ${pkgs.prometheus-node-exporter.bin}/bin/node_exporter \
          ${optionalString (cfg.enabledCollectors != [])
            ''-collectors.enabled ${concatStringsSep "," cfg.enabledCollectors}''} \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port}
      '';
      serviceConfig = {
        User = "nobody";
        Restart  = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
      };
    };
  };
}
