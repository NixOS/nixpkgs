{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (config.boot.supportedFilesystems.glusterfs or false) {

    system.fsPackages = [ pkgs.glusterfs ];

  };
}
