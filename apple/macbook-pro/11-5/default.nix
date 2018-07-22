{ lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/pc/laptop/ssd
    <nixpkgs/nixos/modules/hardware/network/broadcom-43xx.nix>
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Apparently this is currently only supported by ati_unfree drivers, not ati
  hardware.opengl.driSupport32Bit = false;

  services.xserver.videoDrivers = [ "ati" ];
}
