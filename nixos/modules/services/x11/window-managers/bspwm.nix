{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.bspwm;
in

{
  options = {
    services.xserver.windowManager.bspwm = {
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

  config = mkIf (elem "bspwm" wmcfg.enable) {
    services.xserver.windowManager.session = singleton {
      name = "bspwm";
      start = if cfg.startThroughSession
        then cfg.sessionScript
        else ''
            SXHKD_SHELL=/bin/sh ${pkgs.sxhkd}/bin/sxhkd -f 100 &
            ${pkgs.bspwm}/bin/bspwm
        '';
    };
    environment.systemPackages = [ pkgs.bspwm ];
  };
}
