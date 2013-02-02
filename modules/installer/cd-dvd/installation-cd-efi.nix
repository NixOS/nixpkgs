{ config, pkgs, ... }:

{
  require = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_7;
  boot.vesa = false;

  # What follows should probably move into base once the base kernel has the
  # efi boot stub

  # Get a console as soon as the initrd loads fbcon on EFI boot
  boot.initrd.kernelModules = [ "fbcon" ];

  # Enable reading EFI variables via sysfs
  boot.kernelModules = [ "efivars" ];

  # efi-related tools
  environment.systemPackages = [ pkgs.efibootmgr ];

  isoImage.makeEfiBootable = true;
}
