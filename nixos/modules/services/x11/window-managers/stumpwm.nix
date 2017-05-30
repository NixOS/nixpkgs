{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.stumpwm;
in

{
  options = {
    services.xserver.windowManager.stumpwm.enable = mkEnableOption "stumpwm";
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "stumpwm";
      start = ''
        # Set GTK_DATA_PREFIX so that GTK+ can find the themes
        export GTK_DATA_PREFIX=${config.system.path}
        # find theme engines
        export GTK_PATH=${config.system.path}/lib/gtk-3.0:${config.system.path}/lib/gtk-2.0
        # find the cursor themes
        export XCURSOR_PATH = ~/.icons:${config.system.path}/share/icons

        ${pkgs.stumpwm}/bin/stumpwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [
      pkgs.stumpwm
      pkgs.gtk # To get GTK+'s themes.
    ];

    environment.pathsToLink = [ "/share/icons" "/share/themes" ];
  };
}
