{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.domain;
  inherit (lib) concatStringsSep;
in
{
  port = 9222;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-domain-exporter}/bin/domain_exporter \
          --bind ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
