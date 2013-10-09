{ config, pkgs, ... }:

{
  # Move into base image once using 3.10 or later

  require = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_10;

  # Get a console as soon as the initrd loads fbcon on EFI boot
  boot.initrd.kernelModules = [ "fbcon" ];

  isoImage.makeEfiBootable = true;
}
