{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.qtile;
in

{
  config = mkIf (elem "qtile" wmcfg.enable) {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${pkgs.qtile}/bin/qtile
        waitPID=$!
      '';
    }];
    
    environment.systemPackages = [ pkgs.qtile ];
  };
}
