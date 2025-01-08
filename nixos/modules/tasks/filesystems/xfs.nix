{
  config,
  lib,
  pkgs,
  ...
}:

let

  inInitrd = config.boot.initrd.supportedFilesystems.xfs or false;

in

{
  config = lib.mkIf (config.boot.supportedFilesystems.xfs or false) {

    system.fsPackages = [ pkgs.xfsprogs.bin ];

    boot.initrd.availableKernelModules = lib.mkIf inInitrd [
      "xfs"
      "crc32c"
    ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.xfsprogs.bin}/bin/fsck.xfs
      copy_bin_and_libs ${pkgs.xfsprogs.bin}/bin/xfs_repair
    '';

    # Trick just to set 'sh' after the extraUtils nuke-refs.
    boot.initrd.extraUtilsCommandsTest = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      sed -i -e 's,^#!.*,#!'$out/bin/sh, $out/bin/fsck.xfs
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.xfsprogs.bin ];
  };
}
