{ lib, ... }:

{
  services.xserver.libinput.enable = lib.mkDefault true;
}
