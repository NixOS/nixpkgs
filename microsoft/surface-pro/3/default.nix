{ lib, ... }:

{
  # to use the type cover in the initrd
  boot.kernelModules = [ "hid-microsoft" ];

  # TODO: reverse compat
  networking.wireless.enable = lib.mkDefault true;
}
