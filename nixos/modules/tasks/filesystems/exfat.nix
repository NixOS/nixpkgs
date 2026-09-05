{
  config,
  lib,
  pkgs,
  ...
}:
let
  inInitrd = config.boot.initrd.supportedFilesystems.exfat or false;
  inSystem = config.boot.supportedFilesystems.exfat or false;
in
{
  config = {
    system.fsPackages = lib.mkIf (inInitrd || inSystem) [ pkgs.exfatprogs ];

    boot.initrd.availableKernelModules = lib.mkIf inInitrd [ "exfat" ];
  };
}
