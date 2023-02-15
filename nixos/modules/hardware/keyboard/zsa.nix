{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.keyboard.zsa;
  inherit (lib) mkEnableOption mkIf mdDoc;

in
{
  options.hardware.keyboard.zsa = {
    enable = mkEnableOption (mdDoc ''
      udev rules for keyboards from ZSA like the ErgoDox EZ, Planck EZ and Moonlander Mark I.
      You need it when you want to flash a new configuration on the keyboard
      or use their live training in the browser.
      You may want to install the wally-cli package.
    '');
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.zsa-udev-rules ];
  };
}
