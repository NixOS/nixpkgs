{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  hardware.trackpoint.enable = mkDefault true;
  services.tlp.enable = mkDefault true;
  services.xserver.libinput.enable = mkDefault true;
}
