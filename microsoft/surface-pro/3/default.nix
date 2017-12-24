{ lib, ... }:

{
  # to use the type cover in the initrd
  boot.kernelModules = [ "hid-microsoft" ];

  networking.wireless.enable = lib.mkDefault true;
}
