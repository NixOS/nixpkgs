{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (any (fs: fs == "exfat") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.exfat ];

  };
}
