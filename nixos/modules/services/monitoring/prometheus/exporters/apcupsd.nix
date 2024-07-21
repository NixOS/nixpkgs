{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.apcupsd;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9162;
  extraOpts = {
    apcupsdAddress = mkOption {
      type = types.str;
      default = ":3551";
      description = ''
        Address of the apcupsd Network Information Server (NIS).
      '';
    };

    apcupsdNetwork = mkOption {
      type = types.enum ["tcp" "tcp4" "tcp6"];
      default = "tcp";
      description = ''
        Network of the apcupsd Network Information Server (NIS): one of "tcp", "tcp4", or "tcp6".
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-apcupsd-exporter}/bin/apcupsd_exporter \
          -telemetry.addr ${cfg.listenAddress}:${toString cfg.port} \
          -apcupsd.addr ${cfg.apcupsdAddress} \
          -apcupsd.network ${cfg.apcupsdNetwork} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
