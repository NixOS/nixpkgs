{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

  # TODO: boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # This will save you money and possibly your life!
  services.thermald.enable = true;

  # To just use Intel integrated graphics with Intel's open source driver
  # hardware.nvidiaOptimus.disable = true;
}
