{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.apfs or false;

in

{
  config = mkIf (config.boot.supportedFilesystems.apfs or false) {

    system.fsPackages = [ pkgs.apfsprogs ];

    boot.extraModulePackages = [ config.boot.kernelPackages.apfs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "apfs" ];

    # Don't copy apfsck into the initramfs since it does not support repairing the filesystem
  };
}
