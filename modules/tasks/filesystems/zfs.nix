{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "zfs") config.boot.initrd.supportedFilesystems;
  kernel = config.boot.kernelPackages;

in

{
  ###### implementation

  config = mkIf (any (fs: fs == "zfs") config.boot.supportedFilesystems) {

    boot.kernelModules = [ "spl" "zavl" "zcommon" "zfs" "zlib_deflate" "znvpair" "zunicode" ] ;

    boot.initrd.kernelModules = mkIf inInitrd [ "spl" "zavl" "zcommon" "zfs" "zlib_deflate" "znvpair" "zunicode" ] ;

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        cp -v ${kernel.zfs}/sbin/zfs $out/sbin
        cp -v ${kernel.zfs}/sbin/zdb $out/sbin
        cp -v ${kernel.zfs}/sbin/zpool $out/sbin
      '';

    boot.initrd.postDeviceCommands = mkIf inInitrd
      ''
        zpool import -f -a -d /dev
        zfs mount -a
      '';

    system.fsPackages = [ kernel.zfs ];

    environment.systemPackages = [ kernel.zfs ];

    services.udev.packages = [ kernel.zfs ];
  };
}
