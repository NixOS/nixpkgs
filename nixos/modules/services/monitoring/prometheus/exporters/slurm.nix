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
        ${pkgs.prometheus-slurm-exporter}/bin/prometheus-slurm-exporter \
          --listen-address "${cfg.listenAddress}:${toString cfg.port}" \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      Environment = [ "PATH=${pkgs.slurm}/bin/" ];
    };
  };
}
