{
  config,
  lib,
  pkgs,
  ...
}:
let
  ntfsEnabled = config.boot.supportedFilesystems.ntfs or false;
  ntfs3gEnabled = config.boot.supportedFilesystems.ntfs-3g or false;
  ntfsPlusSupported = config.boot.kernelPackages.kernelAtLeast "7.1";
  initrdSupport = config.boot.initrd.supportedFilesystems.ntfs or false;
in
{
  config = lib.mkMerge [
    (lib.mkIf (ntfsEnabled && ntfsPlusSupported && !ntfs3gEnabled) {
      system.fsPackages = [ pkgs.ntfsprogs-plus ];

      boot.initrd.availableKernelModules = lib.optionals initrdSupport [ "ntfs" ];
    })

    (lib.mkIf (ntfs3gEnabled || (ntfsEnabled && !ntfsPlusSupported)) {
      system.fsPackages = [ pkgs.ntfs3g ];

      boot.initrd.availableKernelModules = lib.optionals initrdSupport [ "ntfs3" ];
    })
  ];
}
