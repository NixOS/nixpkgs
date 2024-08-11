{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.metacity;
  inherit (pkgs) metacity;
in

{
  options = {
    services.xserver.windowManager.metacity.enable = mkEnableOption "metacity";
  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "metacity";
        start = ''
          ${metacity}/bin/metacity &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ metacity ];

  };

}
