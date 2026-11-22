{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  inInitrd = config.boot.initrd.supportedFilesystems.f2fs or false;
in
{
  config = mkIf (config.boot.supportedFilesystems.f2fs or false) {

    system.fsPackages = [ pkgs.f2fs-tools ];

    boot.initrd.availableKernelModules = mkIf inInitrd [
      "f2fs"
      "crc32"
    ];

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.f2fs-tools ];
  };
}
