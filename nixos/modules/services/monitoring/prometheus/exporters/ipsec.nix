{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.ipsec;
in
{
  port = 9536;
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      User = "root"; # root user is required to access the ipsec control socket
      RuntimeDirectory = "prometheus-ipsec-exporter";
      ExecStart = ''
        ${pkgs.prometheus-ipsec-exporter}/bin/ipsec_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
