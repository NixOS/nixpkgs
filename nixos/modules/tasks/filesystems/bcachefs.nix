{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "bcachefs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "bcachefs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.bcachefs-tools ];

    # use kernel package with bcachefs support until it's in mainline
    boot.kernelPackages = pkgs.linuxPackages_testing_bcachefs;
    boot.initrd.availableKernelModules = mkIf inInitrd [ "bcachefs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/fsck.bcachefs
      '';

  };
}
