{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.clfswm;
in

{
  config = mkIf (elem "clfswm" wmcfg.enable) {
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
