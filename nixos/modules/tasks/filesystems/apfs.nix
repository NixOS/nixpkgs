{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "apfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "apfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.apfsprogs ];

    boot.extraModulePackages = [ config.boot.kernelPackages.apfs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "apfs" ];

    # Don't copy apfsck into the initramfs since it does not support repairing the filesystem
  };
}
