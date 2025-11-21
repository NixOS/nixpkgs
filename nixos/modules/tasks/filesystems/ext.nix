{
  config,
  lib,
  pkgs,
  ...
}:

let

  hasExtX = s: s.ext2 or s.ext3 or s.ext4 or false;

  inInitrd = hasExtX config.boot.initrd.supportedFilesystems;
  inSystem = hasExtX config.boot.supportedFilesystems;

in

{
  config = {

    boot.supportedFilesystems.ext4 = lib.mkDefault true;
    boot.initrd.supportedFilesystems.ext4 = lib.mkDefault true;

    system.fsPackages = lib.mkIf (inInitrd || inSystem) [
      pkgs.e2fsprogs
    ];

    # As of kernel 4.3, there is no separate ext3 driver (they're also handled by ext4.ko)
    boot.initrd.availableKernelModules = lib.mkIf inInitrd [
      "ext2"
      "ext4"
    ];

    boot.initrd.extraUtilsCommands = lib.mkIf ((!config.boot.initrd.systemd.enable) && inInitrd) ''
      # Copy e2fsck and friends.
      copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/e2fsck
      copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/tune2fs
      ln -sv e2fsck $out/bin/fsck.ext2
      ln -sv e2fsck $out/bin/fsck.ext3
      ln -sv e2fsck $out/bin/fsck.ext4
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf (config.boot.initrd.systemd.enable && inInitrd) [
      pkgs.e2fsprogs
    ];

  };
}
