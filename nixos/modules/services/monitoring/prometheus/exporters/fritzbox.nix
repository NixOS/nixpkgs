{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.fritzbox;
in
{
  port = 9133;
  extraOpts = {
    gatewayAddress = mkOption {
      type = types.str;
      default = "fritz.box";
      description = lib.mdDoc ''
        The hostname or IP of the FRITZ!Box.
      '';
    };

    gatewayPort = mkOption {
      type = types.int;
      default = 49000;
      description = lib.mdDoc ''
        The port of the FRITZ!Box UPnP service.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-fritzbox-exporter}/bin/exporter \
          -listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -gateway-address ${cfg.gatewayAddress} \
          -gateway-port ${toString cfg.gatewayPort} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
