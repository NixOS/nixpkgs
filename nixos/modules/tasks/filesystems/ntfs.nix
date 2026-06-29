{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    (lib.mkIf
      (
        (config.boot.supportedFilesystems.ntfs or false && config.boot.kernelPackages.kernelOlder "7.1")
        || config.boot.supportedFilesystems.ntfs-3g or false
      )
      {
        system.fsPackages = [ pkgs.ntfs3g ];
      }
    )
    (lib.mkIf
      (
        (config.boot.supportedFilesystems.ntfs or false && config.boot.kernelPackages.kernelAtLeast "7.1")
        || config.boot.supportedFilesystems.ntfsplus or false
      )
      {
        system.fsPackages = [ pkgs.ntfsprogs-plus ];
      }
    )
    (lib.mkIf
      (config.boot.supportedFilesystems.ntfsplus or false && config.boot.kernelPackages.kernelOlder "7.1")
      {
        boot = {
          blacklistedKernelModules = [ "ntfs3" ];
          extraModulePackages = [
            config.boot.kernelPackages.ntfs
          ];
        };
      }
    )
    (lib.mkIf
      (
        (
          config.boot.initrd.supportFilesystems.ntfs or false
          && config.boot.kernelPackages.kernelAtLeast "7.1"
        )
        || config.boot.initrd.supportFilesystems.ntfsplus or false
      )
      {
        boot.initrd.availableKernelModules = [ "ntfs" ];
      }
    )
  ];
}
