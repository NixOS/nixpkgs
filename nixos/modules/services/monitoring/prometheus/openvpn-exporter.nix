{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.openvpnExporter;
in {
  options = {
    services.prometheus.openvpnExporter = {
      enable = mkEnableOption "Prometheus OpenVPN exporter";

      listenAddress = mkOption {
        type = types.str;
        default = "[::]";
        description = ''
          Address to listen on for web interface and telemetry.
        '';
      };

      listenPort = mkOption {
        type = types.int;
        default = 9167;
        description = ''
          Port to listen on for web interface and telemetry.
        '';
      };

      telemetryPath = mkOption {
        type = types.str;
        default = "/metrics";
        description = ''
          Path under which to expose metrics.
        '';
      };

      statusPaths = mkOption {
        type = types.listOf types.str;
        description = ''
          Paths to OpenVPN status files. Please configure the OpenVPN option
          <literal>status</literal> accordingly.
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
    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.listenPort;

    systemd.services.prometheus-openvpn-exporter = {
      description = "Prometheus exporter for OpenVPN";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "always";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelModules = true;
        NoNewPrivileges = true;
        WorkingDirectory = /tmp;
        ExecStart = ''
          ${pkgs.prometheus-openvpn-exporter}/bin/openvpn_exporter \
            -openvpn.status_paths "${concatStringsSep "," cfg.statusPaths}" \
            -web.listen-address ${cfg.listenAddress}:${toString cfg.listenPort} \
            -web.telemetry-path ${cfg.telemetryPath}
        '';
      };
    };
  };
}
