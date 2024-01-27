{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.nimdow;
in
{
  options = {
    services.xserver.windowManager.nimdow.enable = mkEnableOption (lib.mdDoc "nimdow");
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "nimdow";
      start = ''
        ${pkgs.nimdow}/bin/nimdow &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.nimdow ];
  };
}
