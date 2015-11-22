{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.swm;
in
{
  options = {
    services.xserver.windowManager.swm.enable = mkEnableOption "swm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton
      { name = "swm";
        start =
          ''
            ${pkgs.sxhkd}/bin/sxhkd &
            ${pkgs.swm}/bin/swm &
            waitPID=$!
          '';
      };
    environment.systemPackages = [ pkgs.swm ];
  };
}
