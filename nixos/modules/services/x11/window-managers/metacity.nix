{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.metacity;
  inherit (pkgs) gnome;
in

{
  options = {
    services.xserver.windowManager.metacity.enable = mkEnableOption "metacity";
  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "metacity";
        start = ''
          ${gnome.metacity}/bin/metacity &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ gnome.metacity ];

  };

}
