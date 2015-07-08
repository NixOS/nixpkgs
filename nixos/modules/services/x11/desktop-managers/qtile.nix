{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.qtile;
in

{
  options = {
    services.xserver.desktopManager.qtile = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the Qtile window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.desktopManager.session = [{
      name = "qtile";
      start = ''
        ${pkgs.qtile}/bin/qtile
        waitPID=$!
      '';
    }];
    
    environment.systemPackages = [ pkgs.qtile ];
  };
}
