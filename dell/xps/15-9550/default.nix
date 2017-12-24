{ lib, ... }:

{
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # To just use Intel integrated graphics with Intel's open source driver
  # hardware.nvidiaOptimus.disable = true;

  services.xserver.libinput.enable = lib.mkDefault true;
}
