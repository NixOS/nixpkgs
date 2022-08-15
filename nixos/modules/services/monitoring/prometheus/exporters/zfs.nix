{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.zfs;
in
{
  port = 9134;
  extraOpts = {
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "dataset-snapshot" ];
      description = lib.mdDoc ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "dataset-filesystem" ];
      description = lib.mdDoc ''
        Collectors to disable which are enabled by default.
      '';
    };
  };
  serviceOpts = {
    path = [ pkgs.zfs ]; # NOTE: the exporter shells out to `zpool`

    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-zfs-exporter";
      ExecStart = ''
        ${pkgs.prometheus-zfs-exporter}/bin/zfs_exporter \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';

      # NOTE: because the exporter shells out to `zpool`, we need to allow access only to /dev/zfs. This is
      # achieved with a combination of DevicePolicy and DeviceAllow.
      PrivateDevices = lib.mkForce false;
      DevicePolicy = "closed";
      DeviceAllow = lib.mkForce [ "/dev/zfs rw" ];
    };
  };
}
