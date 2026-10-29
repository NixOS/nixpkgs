{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  config =
    mkIf (config.boot.supportedFilesystems.ntfs or config.boot.supportedFilesystems.ntfs-3g or false)
      {

        system.fsPackages = [ pkgs.ntfs3g ];

      };
}
