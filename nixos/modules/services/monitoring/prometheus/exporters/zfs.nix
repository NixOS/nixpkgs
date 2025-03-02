{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.zfs;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9134;

  extraOpts = {
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };

    pools = mkOption {
      type = with types; nullOr (listOf str);
      default = [ ];
      description = ''
        Name of the pool(s) to collect, repeat for multiple pools (default: all pools).
      '';
    };
  };

  serviceOpts = {
    # needs zpool
    path = [ config.boot.zfs.package ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-zfs-exporter}/bin/zfs_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          ${concatMapStringsSep " " (x: "--pool=${x}") cfg.pools} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      ProtectClock = false;
      PrivateDevices = false;
    };
  };
}
