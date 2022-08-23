{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.smartctl;
  format = pkgs.formats.yaml {};
  configFile = format.generate "smartctl-exporter.yml" {
    smartctl_exporter = {
      bind_to = "${cfg.listenAddress}:${toString cfg.port}";
      url_path = "/metrics";
      smartctl_location = "${pkgs.smartmontools}/bin/smartctl";
      collect_not_more_than_period = cfg.maxInterval;
      devices = cfg.devices;
    };
  };
in {
  port = 9633;

  extraOpts = {
    devices = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExpression ''
        [ "/dev/sda", "/dev/nvme0n1" ];
      '';
      description = lib.mdDoc ''
        Paths to the disks that will be monitored. Will autodiscover
        all disks if none given.
      '';
    };
    maxInterval = mkOption {
      type = types.str;
      default = "60s";
      example = "2m";
      description = lib.mdDoc ''
        Interval that limits how often a disk can be queried.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
      ];
      CapabilityBoundingSet = [
        "CAP_SYS_RAWIO"
        "CAP_SYS_ADMIN"
      ];
      DevicePolicy = "closed";
      DeviceAllow = lib.mkOverride 100 (
        if cfg.devices != [] then
          cfg.devices
        else [
          "block-blkext rw"
          "block-sd rw"
          "char-nvme rw"
        ]
      );
      ExecStart = ''
        ${pkgs.prometheus-smartctl-exporter}/bin/smartctl_exporter -config ${configFile}
      '';
      PrivateDevices = lib.mkForce false;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      SupplementaryGroups = [ "disk" ];
      SystemCallFilter = [
        "@system-service"
        "~@privileged @resources"
      ];
    };
  };
}
