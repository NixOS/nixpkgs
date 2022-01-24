{ config, lib, pkgs, ... }:

with lib;

{
  config = mkIf (any (fs: fs == "glusterfs") config.boot.supportedFilesystems) {

    system.fsPackages = [ pkgs.glusterfs ];

  };
}
