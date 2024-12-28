{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.reiserfs or false;

in

{
  config = mkIf (config.boot.supportedFilesystems.reiserfs or false) {

    system.fsPackages = [ pkgs.reiserfsprogs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "reiserfs" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.reiserfsprogs}/sbin/reiserfsck
      ln -s reiserfsck $out/bin/fsck.reiserfs
    '';

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.reiserfsprogs ];

  };
}
