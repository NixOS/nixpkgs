{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.hardware.keyboard.zsa;
in
{
  # TODO: make group configurable like in https://github.com/NixOS/nixpkgs/blob/0b2b4b8c4e729535a61db56468809c5c2d3d175c/pkgs/tools/security/nitrokey-app/udev-rules.nix ?
  options.hardware.keyboard.zsa = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for keyboards from ZSA like the ErgoDox EZ, Planck EZ and Moonlander Mark I.
        You need it when you want to flash a new configuration on the keyboard
        or use their live training in the browser.
        Access to the keyboard is granted to users in the "plugdev" group.
        You may want to install the wally-cli package.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.zsa-udev-rules ];
    users.groups.plugdev = {};
  };
}
