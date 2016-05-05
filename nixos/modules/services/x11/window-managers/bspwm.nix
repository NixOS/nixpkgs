{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.bspwm;
in

{
  options = {
    services.xserver.windowManager.bspwm = {
        enable = mkEnableOption "bspwm";
        startThroughSession = mkOption {
            type = with types; bool;
            default = false;
            description = "
                Start the window manager through the script defined in 
                sessionScript. Defaults to the the bspwm-session script
                provided by bspwm
            ";
        };
        sessionScript = mkOption {
            default = "${pkgs.bspwm}/bin/bspwm-session";
            defaultText = "(pkgs.bspwm)/bin/bspwm-session";
            description = "
                The start-session script to use. Defaults to the
                provided bspwm-session script from the bspwm package.

                Does nothing unless `bspwm.startThroughSession` is enabled
            ";
        };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "bspwm";
      start = if cfg.startThroughSession
        then cfg.sessionScript
        else ''
            export _JAVA_AWT_WM_NONREPARENTING=1
            SXHKD_SHELL=/bin/sh ${pkgs.sxhkd}/bin/sxhkd -f 100 &
            ${pkgs.bspwm}/bin/bspwm
        '';
    };
    environment.systemPackages = [ pkgs.bspwm ];
  };
}
