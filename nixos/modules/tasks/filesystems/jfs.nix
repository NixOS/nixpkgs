{ config, lib, pkgs, ... }:

with lib;

let
  inInitrd = any (fs: fs == "jfs") config.boot.initrd.supportedFilesystems;
in
{
  config = mkIf (any (fs: fs == "jfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.jfsutils ];

    boot.initrd.kernelModules = mkIf inInitrd [ "jfs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd ''
      cp -v ${pkgs.jfsutils}/sbin/fsck.jfs "$out/bin/"
    '';
  };
}
