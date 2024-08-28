{ config, pkgs, lib, ... }:

with lib;

let
  inInitrd = config.boot.initrd.supportedFilesystems.f2fs or false;
in
{
  config = mkIf (config.boot.supportedFilesystems.f2fs or false) {

    system.fsPackages = [ pkgs.f2fs-tools ];

    boot.initrd.availableKernelModules = mkIf inInitrd [ "f2fs" "crc32" ];

    boot.initrd.extraUtilsCommands = mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.f2fs-tools}/sbin/fsck.f2fs
    '';

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.f2fs-tools ];
  };
}
