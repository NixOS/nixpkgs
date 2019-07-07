{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.metacity;
  inherit (pkgs) gnome3;
in

{
  options = {
    services.xserver.windowManager.metacity.enable = mkEnableOption "metacity";
  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "metacity";
        start = ''
          ${gnome3.metacity}/bin/metacity &
          waitPID=$!
        '';
      };

    environment.systemPackages = [ gnome3.metacity ];

  };

}
