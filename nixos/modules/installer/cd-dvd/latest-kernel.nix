{ lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems.zfs = false;
  environment.etc."nixos-generate-config.conf".text = ''
    [Defaults]
    Kernel=latest
  '';
}
