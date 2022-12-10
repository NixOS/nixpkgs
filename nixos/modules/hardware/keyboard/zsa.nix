{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.hardware.keyboard.zsa;
in
{
  options.hardware.keyboard.zsa = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables udev rules for keyboards from ZSA like the ErgoDox EZ, Planck EZ and Moonlander Mark I.
        You need it when you want to flash a new configuration on the keyboard
        or use their live training in the browser.
        You may want to install the wally-cli package.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.zsa-udev-rules ];
  };
}
