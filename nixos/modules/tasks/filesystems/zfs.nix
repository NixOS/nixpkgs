{ config, pkgs, ... }:
#
# todo:
#   - crontab for scrubs, etc
#   - zfs tunables
#   - /etc/zfs/zpool.cache handling


with pkgs.lib;

let

  cfgSpl = config.boot.spl;
  cfgSnapshots = config.services.zfs.autoSnapshot;

  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;

  enableAutoSnapshots = cfgSnapshots.enable;
  enableZfs = inInitrd || inSystem || enableAutoSnapshots;

  kernel = config.boot.kernelPackages;

  autosnapPkg = pkgs.zfstools.override {
    zfs = config.boot.kernelPackages.zfs;
  };

  zfsAutoSnap = "${autosnapPkg}/bin/zfs-auto-snapshot";

in

{

  ###### interface

  options = {
    boot.spl.hostid = mkOption {
      default = "";
      example = "0xdeadbeef";
      description = ''
        ZFS uses a system's hostid to determine if a storage pool (zpool) is
        native to this system, and should thus be imported automatically.
        Unfortunately, this hostid can change under linux from boot to boot (by
        changing network adapters, for instance). Specify a unique 32 bit hostid in
        hex here for zfs to prevent getting a random hostid between boots and having to
        manually import pools.
      '';
    };

    services.zfs.autoSnapshot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable the (OpenSolaris-compatible) ZFS auto-snapshotting service.
          Note that you must set the <literal>com.sun:auto-snapshot</literal>
          property to <literal>true</literal> on all datasets which you wish
          to auto-snapshot.

          You can override a child dataset to use, or not use auto-snapshotting
          by setting its flag with the given interval:
          <literal>zfs set com.sun:auto-snapshot:weekly=false DATASET</literal>
        '';
      };

      frequent = mkOption {
        default = 4;
        type = types.int;
        description = ''
          Number of frequent (15-minute) auto-snapshots that you wish to keep.
        '';
      };

      hourly = mkOption {
        default = 24;
        type = types.int;
        description = ''
          Number of hourly auto-snapshots that you wish to keep.
        '';
      };

      daily = mkOption {
        default = 7;
        type = types.int;
        description = ''
          Number of daily auto-snapshots that you wish to keep.
        '';
      };

      weekly = mkOption {
        default = 4;
        type = types.int;
        description = ''
          Number of weekly auto-snapshots that you wish to keep.
        '';
      };

      monthly = mkOption {
        default = 12;
        type = types.int;
        description = ''
          Number of monthly auto-snapshots that you wish to keep.
        '';
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf enableZfs {
      boot = {
        kernelModules = [ "spl" "zfs" ] ;
        extraModulePackages = [ kernel.zfs kernel.spl ];
        extraModprobeConfig = mkIf (cfgSpl.hostid != "") ''
          options spl spl_hostid=${cfgSpl.hostid}
        '';
      };

      boot.initrd = mkIf inInitrd {
        kernelModules = [ "spl" "zfs" ] ;
        extraUtilsCommands =
          ''
            cp -v ${kernel.zfs}/sbin/zfs $out/bin
            cp -v ${kernel.zfs}/sbin/zdb $out/bin
            cp -v ${kernel.zfs}/sbin/zpool $out/bin
            cp -pdv ${kernel.zfs}/lib/lib*.so* $out/lib
            cp -pdv ${pkgs.zlib}/lib/lib*.so* $out/lib
          '';
        postDeviceCommands =
          ''
            zpool import -f -a
          '';
      };

      systemd.services."zpool-import" = {
        description = "Import zpools";
        after = [ "systemd-udev-settle.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${kernel.zfs}/sbin/zpool import -f -a";
        };
        restartIfChanged = false;
      };

      systemd.services."zfs-mount" = {
        description = "Mount ZFS Volumes";
        after = [ "zpool-import.service" ];
        wantedBy = [ "local-fs.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${kernel.zfs}/sbin/zfs mount -a";
          ExecStop = "${kernel.zfs}/sbin/zfs umount -a";
        };
        restartIfChanged = false;
      };

      system.fsPackages = [ kernel.zfs ];                  # XXX: needed? zfs doesn't have (need) a fsck
      environment.systemPackages = [ kernel.zfs ];
      services.udev.packages = [ kernel.zfs ];             # to hook zvol naming, etc.
    })

    (mkIf enableAutoSnapshots {
      systemd.services."zfs-snapshot-frequent" = {
        description = "ZFS auto-snapshotting every 15 mins";
        after = [ "zpool-import.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} frequent ${toString cfgSnapshots.frequent}";
        };
        restartIfChanged = false;
        startAt = "*:15,30,45";
      };

      systemd.services."zfs-snapshot-hourly" = {
        description = "ZFS auto-snapshotting every hour";
        after = [ "zpool-import.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} hourly ${toString cfgSnapshots.hourly}";
        };
        restartIfChanged = false;
        startAt = "hourly";
      };

      systemd.services."zfs-snapshot-daily" = {
        description = "ZFS auto-snapshotting every day";
        after = [ "zpool-import.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} daily ${toString cfgSnapshots.daily}";
        };
        restartIfChanged = false;
        startAt = "daily";
      };

      systemd.services."zfs-snapshot-weekly" = {
        description = "ZFS auto-snapshotting every week";
        after = [ "zpool-import.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} weekly ${toString cfgSnapshots.weekly}";
        };
        restartIfChanged = false;
        startAt = "weekly";
      };

      systemd.services."zfs-snapshot-monthly" = {
        description = "ZFS auto-snapshotting every month";
        after = [ "zpool-import.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${zfsAutoSnap} monthly ${toString cfgSnapshots.monthly}";
        };
        restartIfChanged = false;
        startAt = "monthly";
      };
    })
  ];
}
