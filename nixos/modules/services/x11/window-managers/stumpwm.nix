{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.stumpwm;
in

{
  options = {
    services.xserver.windowManager.stumpwm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable the stumpwm tiling window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm";
      start = "
        ${pkgs.stumpwm}/bin/stumpwm
      ";
    };
    environment.systemPackages = [ pkgs.stumpwm ];
  };
}
