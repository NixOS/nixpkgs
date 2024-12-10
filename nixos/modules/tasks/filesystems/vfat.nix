{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.vfat or false;

in

{
  config = mkIf (config.boot.supportedFilesystems.vfat or false) {

    system.fsPackages = [
      pkgs.dosfstools
      pkgs.mtools
    ];

    boot.initrd.kernelModules = mkIf inInitrd [
      "vfat"
      "nls_cp437"
      "nls_iso8859-1"
    ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.dosfstools}/sbin/dosfsck
      ln -sv dosfsck $out/bin/fsck.vfat
    '';

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.dosfstools ];

  };
}
