{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.keylight;
in
{
  port = 9288;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-keylight-exporter}/bin/keylight_exporter \
          -metrics.addr ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
