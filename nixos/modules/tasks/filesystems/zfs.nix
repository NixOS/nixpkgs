{ config, pkgs, ... }:
#
# todo:
#   - crontab for scrubs, etc
#   - zfs tunables
#   - /etc/zfs/zpool.cache handling


with pkgs.lib;

let

  cfgSpl = config.boot.spl;
  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  inSystem = any (fs: fs == "zfs") config.boot.supportedFilesystems;
  kernel = config.boot.kernelPackages;

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
  };

  ###### implementation

  config = mkIf ( inInitrd || inSystem ) {

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
        '';
      postDeviceCommands =
        ''
          zpool import -f -a -d /dev
          zfs mount -a
        '';
    };

    systemd.services."zpool-import" = {
      description = "Import zpools";
      after = [ "systemd-udev-settle.service" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        restartIfChanged = false;
        ExecStart = "${kernel.zfs}/sbin/zpool import -f -a -d /dev";
      };
    };

    systemd.services."zfs-mount" = {
      description = "Mount zfs volumes";
      after = [ "zpool-import.service" ];
      wantedBy = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        restartIfChanged = false;
        ExecStart = "${kernel.zfs}/sbin/zfs mount -a";
        ExecStop = "${kernel.zfs}/sbin/zfs umount -a";
      };
    };

    system.fsPackages = [ kernel.zfs ];                  # XXX: needed? zfs doesn't have (need) a fsck
    environment.systemPackages = [ kernel.zfs ];
    services.udev.packages = [ kernel.zfs ];             # to hook zvol naming, etc. 
  };
}
