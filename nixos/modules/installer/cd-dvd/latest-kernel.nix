{ lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  isoImage.configurationName = lib.mkAfter [
    "Latest Kernel (${pkgs.linuxPackages_latest.kernel.version})"
  ];
  boot.supportedFilesystems.zfs = false;
  environment.etc."nixos-generate-config.conf".text = ''
    [Defaults]
    Kernel=latest
  '';
}
