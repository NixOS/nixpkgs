{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.kernelPackages = pkgs.linuxPackages_5_1;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

}
