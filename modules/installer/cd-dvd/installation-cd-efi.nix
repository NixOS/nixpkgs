{ config, pkgs, ... }:

{
  require = [ ./installation-cd-minimal.nix ];

  boot.kernelPackages = pkgs.linuxPackages_3_8;
  boot.vesa = false;

  # What follows should probably move into base once the base kernel has the
  # efi boot stub

  # Get a console as soon as the initrd loads fbcon on EFI boot
  # Enable reading EFI variables via sysfs
  # !!! Needing efivars will only be necessary until http://article.gmane.org/gmane.linux.kernel.efi/773 is merged
  boot.initrd.kernelModules = [ "fbcon" "efivars" ];

  # efi-related tools
  environment.systemPackages = [ pkgs.efibootmgr ];

  isoImage.makeEfiBootable = true;
}
