{ lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems.zfs = false;
}
