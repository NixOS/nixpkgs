{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.podman;
in
{
  port = 9882;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-podman-exporter}/bin/prometheus-podman-exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
