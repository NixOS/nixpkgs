{ lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  isoImage.configurationName = lib.mkAfter [
    "Latest Kernel (${pkgs.linuxPackages_latest.kernel.version})"
  ];
  boot.supportedFilesystems.zfs = false;
}
