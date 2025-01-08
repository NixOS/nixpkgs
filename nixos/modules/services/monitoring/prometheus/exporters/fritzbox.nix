{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.fritzbox;
  inherit (lib) lib.mkOption types concatStringsSep;
in
{
  port = 9133;
  extraOpts = {
    gatewayAddress = lib.mkOption {
      type = lib.types.str;
      default = "fritz.box";
      description = ''
        The hostname or IP of the FRITZ!Box.
      '';
    };

    gatewayPort = lib.mkOption {
      type = lib.types.int;
      default = 49000;
      description = ''
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
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
