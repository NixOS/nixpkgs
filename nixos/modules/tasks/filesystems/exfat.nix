{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (any (fs: fs == "exfat") config.boot.supportedFilesystems) {
    system.fsPackages = if config.boot.kernelPackages.kernelOlder "5.7" then [
      pkgs.exfat # FUSE
    ] else [
      pkgs.exfatprogs # non-FUSE
    ];
  };
}
