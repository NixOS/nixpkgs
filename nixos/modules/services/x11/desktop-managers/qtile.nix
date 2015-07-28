{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.qtile;
in

{
  options = {
    services.xserver.windowManager.qtile.enable = mkEnableOption "qtile";
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
