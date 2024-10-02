{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.cwm;
in
{
  options = {
    services.xserver.windowManager.cwm.enable = mkEnableOption "cwm";
  };
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton
      { name = "cwm";
        start =
          ''
            cwm &
            waitPID=$!
          '';
      };
    environment.systemPackages = [ pkgs.cwm ];
  };
}
