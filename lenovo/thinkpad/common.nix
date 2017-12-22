{ lib, pkgs, ... }:

let
  inherit (lib) mkDefault;
in

{
  boot = {
    kernelModules = [ "tp_smapi" ];
    extraModulePackages = with config.boot.kernelPackages; [ tp_smapi ];
  };

  hardware.trackpoint.enable = mkDefault true;
  services.tlp.enable = mkDefault true;
  services.xserver.libinput.enable = mkDefault true;
}
