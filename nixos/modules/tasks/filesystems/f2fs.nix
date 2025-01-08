{
  config,
  pkgs,
  lib,
  ...
}:

let
  inInitrd = config.boot.initrd.supportedFilesystems.f2fs or false;
in
{
  config = lib.mkIf (config.boot.supportedFilesystems.f2fs or false) {

    system.fsPackages = [ pkgs.f2fs-tools ];

    boot.initrd.availableKernelModules = lib.mkIf inInitrd [
      "f2fs"
      "crc32"
    ];

    boot.initrd.extraUtilsCommands = lib.mkIf (inInitrd && !config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.f2fs-tools}/sbin/fsck.f2fs
    '';

    boot.initrd.systemd.initrdBin = lib.mkIf inInitrd [ pkgs.f2fs-tools ];
  };
}
