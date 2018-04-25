{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.varnish;
in
{
  port = 9131;
  serviceOpts = {
    path = [ pkgs.varnish ];
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-varnish-exporter}/bin/prometheus_varnish_exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
