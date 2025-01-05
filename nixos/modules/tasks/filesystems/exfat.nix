{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  config = mkIf (config.boot.supportedFilesystems.exfat or false) {
    system.fsPackages =
      if config.boot.kernelPackages.kernelOlder "5.7" then
        [
          pkgs.exfat # FUSE
        ]
      else
        [
          pkgs.exfatprogs # non-FUSE
        ];
  };
}
