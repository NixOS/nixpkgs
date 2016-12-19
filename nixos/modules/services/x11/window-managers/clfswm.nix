{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.clfswm;
in

{
  options = {
    services.xserver.windowManager.clfswm.enable = mkEnableOption "clfswm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "clfswm";
      start = ''
        ${pkgs.clfswm}/bin/clfswm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.clfswm ];
  };
}
