{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.xfs or false;

in

{
  config = mkIf (config.boot.supportedFilesystems.xfs or false) {

    system.fsPackages = [ pkgs.xfsprogs.bin ];

    boot.initrd.availableKernelModules = mkIf inInitrd [ "xfs" "crc32c" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        copy_bin_and_libs ${pkgs.xfsprogs.bin}/bin/fsck.xfs
        copy_bin_and_libs ${pkgs.xfsprogs.bin}/bin/xfs_repair
      '';

    # Trick just to set 'sh' after the extraUtils nuke-refs.
    boot.initrd.extraUtilsCommandsTest = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        sed -i -e 's,^#!.*,#!'$out/bin/sh, $out/bin/fsck.xfs
      '';

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.xfsprogs.bin ];
  };
}
