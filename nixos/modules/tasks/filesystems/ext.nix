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

    system.fsPackages = lib.mkIf (inInitrd || inSystem) [
      pkgs.e2fsprogs
    ];

    # As of kernel 4.3, there is no separate ext3 driver (they're also handled by ext4.ko)
    boot.initrd.availableKernelModules = lib.mkIf inInitrd [
      "ext2"
      "ext4"
    ];

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.e2fsprogs ];

  };
}
