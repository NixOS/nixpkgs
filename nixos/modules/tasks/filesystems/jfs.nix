{ config, lib, pkgs, ... }:

with lib;

let
  inInitrd = any (fs: fs == "jfs") config.boot.initrd.supportedFilesystems;
in
{
  config = mkIf (any (fs: fs == "jfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.jfsutils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "jfs" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.jfsutils}/sbin/fsck.jfs
    '';
  };
}
