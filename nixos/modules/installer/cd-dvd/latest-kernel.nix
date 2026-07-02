{ lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems.zfs = false;
  boot.supportedFilesystems.bcachefs = true;
  environment.etc."nixos-generate-config.conf".text = ''
    [Defaults]
    Kernel=latest
  '';
}
