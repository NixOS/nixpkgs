{ config, pkgs, lib, ... }:

with lib;

let
  inInitrd = any (fs: fs == "f2fs") config.boot.initrd.supportedFilesystems;
in
{
  config = mkIf (any (fs: fs == "f2fs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.f2fs-tools ];

    boot.initrd.availableKernelModules = mkIf inInitrd [ "f2fs" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd ''
      mkdir -p $out/bin $out/lib
      cp -v   ${pkgs.f2fs-tools}/sbin/fsck.f2fs $out/bin
      cp -pdv ${pkgs.f2fs-tools}/lib/lib*.so.* $out/lib
    '';
  };
}
