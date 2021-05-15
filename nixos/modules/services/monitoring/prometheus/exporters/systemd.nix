{ config, pkgs, lib, ... }:

with lib;

let cfg = config.services.prometheus.exporters.systemd;

in {
  port = 9558;

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-systemd-exporter}/bin/systemd_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port}
      '';
    };
  };
}
