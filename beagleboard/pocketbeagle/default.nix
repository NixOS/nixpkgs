{ lib, ... }:

{
  boot.kernelParams = [ "console=ttyO0,115200n8" ];

  boot.loader = {
    generic-extlinux-compatible.enable = lib.mkDefault true;
    grub.enable = lib.mkDefault false;
  };
}
