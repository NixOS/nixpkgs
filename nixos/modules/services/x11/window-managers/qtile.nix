{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in

{
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "qtile" ]);
    };
  };

  config = mkIf (elem "qtile" wmcfg.select) {
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
