{
  config,
  lib,
  pkgs,
  ...
}:

let

  inInitrd = config.boot.initrd.supportedFilesystems.vfat or false;

in

{
  config = lib.mkIf (config.boot.supportedFilesystems.vfat or false) {

    system.fsPackages = [
      pkgs.dosfstools
      pkgs.mtools
    ];

    boot.initrd.kernelModules = lib.mkIf inInitrd [
      "vfat"
      "nls_cp437"
      "nls_iso8859-1"
    ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.dosfstools}/sbin/dosfsck
      ln -sv dosfsck $out/bin/fsck.vfat
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.dosfstools ];

  };
}
