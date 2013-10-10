{ config, pkgs, ... }:

{
  config = {

    system.fsPackages = [ pkgs.e2fsprogs ];

    boot.initrd.availableKernelModules = [ "ext2" "ext3" "ext4" ];

    boot.initrd.extraUtilsCommands =
      ''
        # Copy e2fsck and friends.
        cp -v ${pkgs.e2fsprogs}/sbin/e2fsck $out/bin
        cp -v ${pkgs.e2fsprogs}/sbin/tune2fs $out/bin
        ln -sv e2fsck $out/bin/fsck.ext2
        ln -sv e2fsck $out/bin/fsck.ext3
        ln -sv e2fsck $out/bin/fsck.ext4
        cp -pdv ${pkgs.e2fsprogs}/lib/lib*.so.* $out/lib
      '';

  };
}
