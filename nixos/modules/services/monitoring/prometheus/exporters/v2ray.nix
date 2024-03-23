{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.v2ray;
in
{
  port = 9299;
  extraOpts = {
    v2rayEndpoint = mkOption {
      type = types.str;
      default = "127.0.0.1:54321";
      description = lib.mdDoc ''
        v2ray grpc api endpoint
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-v2ray-exporter}/bin/v2ray-exporter \
          --v2ray-endpoint ${cfg.v2rayEndpoint} \
          --listen ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
