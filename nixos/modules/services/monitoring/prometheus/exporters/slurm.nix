{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.slurm;
in
{
  port = 9341;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-slurm-exporter}/bin/slurm_exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
