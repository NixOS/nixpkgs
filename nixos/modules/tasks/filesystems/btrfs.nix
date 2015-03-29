{ config, lib, pkgs, ... }:

with lib;

let

  inInitrd = any (fs: fs == "btrfs") config.boot.initrd.supportedFilesystems;

in

{
  config = mkIf (any (fs: fs == "btrfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.btrfsProgs ];

    boot.initrd.kernelModules = mkIf inInitrd [ "btrfs" "crc32c" ];

    boot.initrd.extraUtilsCommands = mkIf inInitrd
      ''
        copy_bin_and_libs ${pkgs.btrfsProgs}/bin/btrfs
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

    # !!! This is broken.  There should be a udev rule to do this when
    # new devices are discovered.
    jobs.udev.postStart =
      ''
        ${pkgs.btrfsProgs}/bin/btrfs device scan
      '';

  };
}
