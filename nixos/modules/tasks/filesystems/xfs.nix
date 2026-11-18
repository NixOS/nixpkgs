{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  inInitrd = config.boot.initrd.supportedFilesystems.xfs or false;

in

{
  config = mkIf (config.boot.supportedFilesystems.xfs or false) {

    system.fsPackages = [ pkgs.xfsprogs.bin ];

    systemd = {
      packages = [ pkgs.xfsprogs.out ];
      services.xfs_scrub_all.path = [ pkgs.util-linux.bin ]; # lsblk
    };

    boot.initrd.availableKernelModules = mkIf inInitrd [
      "xfs"
      "crc32c"
    ];

    boot.initrd.systemd.initrdBin = mkIf inInitrd [ pkgs.xfsprogs.bin ];
  };
}
