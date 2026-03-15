{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.kvrocks;
  inherit (lib) concatStringsSep;
in
{
  port = 9121;
  serviceOpts = {
    serviceConfig = {
      RestrictAddressFamilies = [ "AF_UNIX" ];
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-kvrocks-exporter} \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
