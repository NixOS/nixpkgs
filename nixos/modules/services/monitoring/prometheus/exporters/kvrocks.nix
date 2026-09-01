{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.kvrocks;
in
{
  port = 9121;
  serviceOpts = {
    serviceConfig = {
      RestrictAddressFamilies = [ "AF_UNIX" ];
      ExecStart = "${lib.getExe pkgs.prometheus-kvrocks-exporter} -web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${lib.escapeShellArgs cfg.extraFlags}";
    };
  };
}
