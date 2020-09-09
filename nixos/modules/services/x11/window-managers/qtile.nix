{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
in

{
  options = {
    services.xserver.windowManager.qtile.enable = mkEnableOption "qtile";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${pkgs.qtile}/bin/qtile &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ pkgs.qtile ];
  };
}
