{ config, lib, pkgs, ... }:
# TODO: make ecryptfs work in initramfs?

with lib;

{
  config = mkIf (any (fs: fs == "ecryptfs") config.boot.supportedFilesystems) {
    system.fsPackages = [ pkgs.ecryptfs ];
    security.wrappers = {
      "mount.ecryptfs_private".source = "${pkgs.ecryptfs.out}/bin/mount.ecryptfs_private";
      "umount.ecryptfs_private".source = "${pkgs.ecryptfs.out}/bin/umount.ecryptfs_private";
    };
  };
}
