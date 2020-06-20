{ lib, ... }:

{
  imports = [ ../../hdd ];

  # Hard disk protection if the laptop falls:
  services.hdapsd.enable = lib.mkDefault true;
}
