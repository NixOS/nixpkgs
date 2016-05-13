{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.notion;
in

{
  config = mkIf (elem "notion" wmcfg.enable) {
    services.xserver.windowManager = {
      session = [{
        name = "notion";
        start = ''
          ${pkgs.notion}/bin/notion &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = [ pkgs.notion ];
  };
}
