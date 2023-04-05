{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.openvpn;
in {
  port = 9176;
  extraOpts = {
    statusPaths = mkOption {
      type = types.listOf types.str;
      description = lib.mdDoc ''
        Paths to OpenVPN status files. Please configure the OpenVPN option
        `status` accordingly.
      '';
    };
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      PrivateDevices = true;
      ProtectKernelModules = true;
      NoNewPrivileges = true;
      ExecStart = ''
        ${pkgs.prometheus-openvpn-exporter}/bin/openvpn_exporter \
          -openvpn.status_paths "${concatStringsSep "," cfg.statusPaths}" \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -web.telemetry-path ${cfg.telemetryPath}
      '';
    };
  };
}
