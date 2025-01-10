{
  config,
  lib,
  pkgs,
  ...
}:
# TODO: make ecryptfs work in initramfs?

with lib;

{
  config = mkIf (config.boot.supportedFilesystems.ecryptfs or false) {
    system.fsPackages = [ pkgs.ecryptfs ];
    security.wrappers = {
      "mount.ecryptfs_private" = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.ecryptfs.out}/bin/mount.ecryptfs_private";
      };
      "umount.ecryptfs_private" = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.ecryptfs.out}/bin/umount.ecryptfs_private";
      };
    };
  };
}
