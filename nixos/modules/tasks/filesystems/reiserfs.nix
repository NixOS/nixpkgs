{ config, pkgs, ... }:

with pkgs.lib;

let

  inInitrd = any (fs: fs == "reiserfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "reiserfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.reiserfsprogs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "reiserfs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        cp -v ${pkgs.reiserfsprogs}/sbin/reiserfsck $out/bin
        ln -sv reiserfsck $out/bin/fsck.reiserfs
      '';

  };
}
