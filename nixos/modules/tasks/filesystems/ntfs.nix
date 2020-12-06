{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (any (fs: fs == "ntfs" || fs == "ntfs-3g") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.ntfs3g ];

  };
}
