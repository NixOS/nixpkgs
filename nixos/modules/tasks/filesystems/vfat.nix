{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "vfat") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "vfat") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.dosfstools ];

    boot.initrd.kernelModules = mkIf inInitrd [ "vfat" "nls_cp437" "nls_iso8859-1" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable)
      ''
        copy_bin_and_libs ${pkgs.dosfstools}/sbin/dosfsck
        ln -sv dosfsck $out/bin/fsck.vfat
      '';

  };
}
