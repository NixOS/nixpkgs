{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  config = mkIf (config.boot.supportedFilesystems.glusterfs or false) {

    system.fsPackages = [ pkgs.glusterfs ];

  };
}
