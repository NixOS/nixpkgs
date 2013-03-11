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
        changing network adapaters, for instance). Specify a unique 32 bit hostid in
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
          cp -v ${kernel.zfs}/sbin/zfs $out/sbin
          cp -v ${kernel.zfs}/sbin/zdb $out/sbin
          cp -v ${kernel.zfs}/sbin/zpool $out/sbin
        '';
      postDeviceCommands =
        ''
          zpool import -f -a -d /dev
          zfs mount -a
        '';
    };

    system.fsPackages = [ kernel.zfs ];                  # XXX: needed? zfs doesn't have a fsck
    environment.systemPackages = [ kernel.zfs ];
    services.udev.packages = [ kernel.zfs ];             # to hook zvol naming, etc. 
  };
}
