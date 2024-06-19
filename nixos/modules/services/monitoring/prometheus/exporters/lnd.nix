{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.lnd;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9092;
  extraOpts = {
    lndHost = mkOption {
      type = types.str;
      default = "localhost:10009";
      description = ''
        lnd instance gRPC address:port.
      '';
    };

    lndTlsPath = mkOption {
      type = types.path;
      description = ''
        Path to lnd TLS certificate.
      '';
    };

    lndMacaroonDir = mkOption {
      type = types.path;
      description = ''
        Path to lnd macaroons.
      '';
    };
  };
  serviceOpts.serviceConfig = {
    ExecStart = ''
      ${pkgs.prometheus-lnd-exporter}/bin/lndmon \
        --prometheus.listenaddr=${cfg.listenAddress}:${toString cfg.port} \
        --prometheus.logdir=/var/log/prometheus-lnd-exporter \
        --lnd.host=${cfg.lndHost} \
        --lnd.tlspath=${cfg.lndTlsPath} \
        --lnd.macaroondir=${cfg.lndMacaroonDir} \
        ${concatStringsSep " \\\n  " cfg.extraFlags}
    '';
    LogsDirectory = "prometheus-lnd-exporter";
    ReadOnlyPaths = [ cfg.lndTlsPath cfg.lndMacaroonDir ];
  };
}
