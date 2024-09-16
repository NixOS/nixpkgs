{ lib, pkgs, config, ... }:
let
  cfg = config.services.zfs.autoReplication;
  recursive = lib.optionalString cfg.recursive " --recursive";
  followDelete = lib.optionalString cfg.followDelete " --follow-delete";
in {
  options = {
    services.zfs.autoReplication = {
      enable = lib.mkEnableOption "ZFS snapshot replication";

      followDelete = lib.mkOption {
        description = "Remove remote snapshots that don't have a local correspondent.";
        default = true;
        type = lib.types.bool;
      };

      host = lib.mkOption {
        description = "Remote host where snapshots should be sent. `lz4` is expected to be installed on this host.";
        example = "example.com";
        type = lib.types.str;
      };

      identityFilePath = lib.mkOption {
        description = "Path to SSH key used to login to host.";
        example = "/home/username/.ssh/id_rsa";
        type = lib.types.path;
      };

      localFilesystem = lib.mkOption {
        description = "Local ZFS filesystem from which snapshots should be sent.  Defaults to the attribute name.";
        example = "pool/file/path";
        type = lib.types.str;
      };

      remoteFilesystem = lib.mkOption {
        description = "Remote ZFS filesystem where snapshots should be sent.";
        example = "pool/file/path";
        type = lib.types.str;
      };

      recursive = lib.mkOption {
        description = "Recursively discover snapshots to send.";
        default = true;
        type = lib.types.bool;
      };

      username = lib.mkOption {
        description = "Username used by SSH to login to remote host.";
        example = "username";
        type = lib.types.str;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.lz4
    ];

    systemd.services.zfs-replication = {
      after = [
        "zfs-snapshot-daily.service"
        "zfs-snapshot-frequent.service"
        "zfs-snapshot-hourly.service"
        "zfs-snapshot-monthly.service"
        "zfs-snapshot-weekly.service"
      ];
      description = "ZFS Snapshot Replication";
      documentation = [
        "https://github.com/alunduil/zfs-replicate"
      ];
      restartIfChanged = false;
      serviceConfig.ExecStart = "${pkgs.zfs-replicate}/bin/zfs-replicate${recursive} -l ${lib.escapeShellArg cfg.username} -i ${lib.escapeShellArg cfg.identityFilePath}${followDelete} ${lib.escapeShellArg cfg.host} ${lib.escapeShellArg cfg.remoteFilesystem} ${lib.escapeShellArg cfg.localFilesystem}";
      wantedBy = [
        "zfs-snapshot-daily.service"
        "zfs-snapshot-frequent.service"
        "zfs-snapshot-hourly.service"
        "zfs-snapshot-monthly.service"
        "zfs-snapshot-weekly.service"
      ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ alunduil ];
  };
}
