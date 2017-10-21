{ config, pkgs, ... }:

{
  config = {

    system.fsPackages = [ pkgs.e2fsprogs ];

    # As of kernel 4.3, there is no separate ext3 driver (they're also handled by ext4.ko)
    boot.initrd.availableKernelModules = [ "ext2" "ext4" ];

    boot.initrd.extraUtilsCommands =
      ''
        # Copy e2fsck and friends.
        copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/e2fsck
        copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/tune2fs
        ln -sv e2fsck $out/bin/fsck.ext2
        ln -sv e2fsck $out/bin/fsck.ext3
        ln -sv e2fsck $out/bin/fsck.ext4
      '';

  };
}
