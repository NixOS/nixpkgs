{
  config,
  lib,
  pkgs,
  ...
}:

let

  inInitrd = config.boot.initrd.supportedFilesystems.reiserfs or false;

in

{
  config = lib.mkIf (config.boot.supportedFilesystems.reiserfs or false) {

    system.fsPackages = [ pkgs.reiserfsprogs ];

    boot.initrd.kernelModules = lib.mkIf inInitrd [ "reiserfs" ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.reiserfsprogs}/sbin/reiserfsck
      ln -s reiserfsck $out/bin/fsck.reiserfs
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.reiserfsprogs ];

  };
}
