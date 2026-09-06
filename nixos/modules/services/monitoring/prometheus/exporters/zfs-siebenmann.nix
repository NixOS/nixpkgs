{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.zfs-siebenmann;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionalString
    ;
in
{
  port = 9700;

  extraOpts = {
    pools = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        Name of the pool(s) to collect, repeat for multiple pools (default: all pools).
      '';
    };

    depth = mkOption {
      type = types.int;
      default = 1;
      description = ''
        Depth of the vdev tree to report on.
        0 is the pool, 1 is top level vdevs, 2 is devices too.
      '';
    };

    fullPath = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Report the full path of disks.
      '';
    };
  };

  serviceOpts = {
    # needs zpool
    path = [ config.boot.zfs.package ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-siebenmann-zfs-exporter}/bin/zfs_exporter \
          --listen-addr ${cfg.listenAddress}:${toString cfg.port} \
          --depth ${toString cfg.depth} \
          ${optionalString cfg.fullPath "--fullpath"} \
          ${concatStringsSep " " (map (p: "--pool=${p}") cfg.pools)} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      ProtectClock = false;
      PrivateDevices = false;
    };
  };
}
