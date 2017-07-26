{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.unifiExporter;
in {
  options = {
    services.prometheus.unifiExporter = {
      enable = mkEnableOption "prometheus unifi exporter";

      port = mkOption {
        type = types.int;
        default = 9130;
        description = ''
          Port to listen on.
        '';
      };

      unifiAddress = mkOption {
        type = types.str;
        example = "https://10.0.0.1:8443";
        description = ''
          URL of the UniFi Controller API.
        '';
      };

      unifiInsecure = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled skip the verification of the TLS certificate of the UniFi Controller API.
          Use with caution.
        '';
      };
      
      unifiUsername = mkOption {
        type = types.str;
        example = "ReadOnlyUser";
        description = ''
          username for authentication against UniFi Controller API.
        '';
      };
      
      unifiPassword = mkOption {
        type = types.str;
        description = ''
          Password for authentication against UniFi Controller API.
        '';
      };
      
      unifiTimeout = mkOption {
        type = types.str;
        default = "5s";
        example = "2m";
        description = ''
          Timeout including unit for UniFi Controller API requests.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Extra commandline options when launching the unifi exporter.
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

    systemd.services.prometheus-unifi-exporter = {
      description = "Prometheus exporter for UniFi Controller metrics";
      unitConfig.Documentation = "https://github.com/mdlayher/unifi_exporter";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nobody";
        Restart = "always";
        PrivateTmp = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-unifi-exporter}/bin/unifi_exporter \
            -telemetry.addr :${toString cfg.port} \
            -unifi.addr ${cfg.unifiAddress} \
            -unifi.username ${cfg.unifiUsername} \
            -unifi.password ${cfg.unifiPassword} \
            -unifi.timeout ${cfg.unifiTimeout} \
            ${optionalString cfg.unifiInsecure "-unifi.insecure" } \
            ${concatStringsSep " \\\n  " cfg.extraFlags}
        '';
      };
    };
  };
}
