{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.cardboard;
in

{
  options = {
    services.xserver.windowManager.cardboard.enable = mkEnableOption (lib.mdDoc "cardboard");
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "cardboard";
      start = ''
        ${pkgs.cardboard}/bin/cardboard &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.cardboard ];
  };
}
