{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "btrfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "btrfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.btrfs-progs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "btrfs" "crc32c" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        copy_bin_and_libs ${pkgs.btrfs-progs}/bin/btrfs
        ln -sv btrfs $out/bin/btrfsck
        ln -sv btrfsck $out/bin/fsck.btrfs
      '';

    boot.initrd.extraUtilsCommandsTest = mkIf inInitrd
      ''
        $out/bin/btrfs --version
      '';

    boot.initrd.postDeviceCommands = mkIf inInitrd
      ''
        btrfs device scan
      '';
  };
}
