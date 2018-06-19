{ config, pkgs, lib, ... }:

with lib;

let
  inInitrd = any (fs: fs == "f2fs") config.boot.initrd.supportedFilesystems;
in
{
  config = mkIf (any (fs: fs == "f2fs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.f2fs-tools ];

    boot.initrd.availableKernelModules = mkIf inInitrd [ "f2fs" "crc32" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd ''
      copy_bin_and_libs ${pkgs.f2fs-tools}/sbin/fsck.f2fs
      ${optionalString (any (fs: fs.autoResize && fs.fsType = "f2fs") fileSystems) ''
        # We need f2fs-tools' tools to resize filesystems
        copy_bin_and_libs ${pkgs.f2fs-tools}/sbin/resize.f2fs
      ''}

    '';
  };
}
