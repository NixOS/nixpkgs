{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "reiserfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "reiserfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.reiserfsprogs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "reiserfs" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        copy_bin_and_libs ${pkgs.reiserfsprogs}/sbin/reiserfsck
        ln -s reiserfsck $out/bin/fsck.reiserfs
      '';

  };
}
