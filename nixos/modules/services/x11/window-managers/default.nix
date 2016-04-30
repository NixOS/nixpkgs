{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager;
  wms = [
    "afterstep"
    "awesome"
    "bspwm"
    "clfswm"
    "compiz"
    "dwm"
    "exwm"
    "fluxbox"
    "herbstluftwm"
    "i3"
    "icewm"
    "jwm"
    "metacity"
    "notion"
    "openbox"
    "oroborus"
    "qtile"
    "ratpoison"
    "sawfish"
    "spectrwm"
    "stumpwm"
    "twm"
    "windowlab"
    "windowmaker"
    "wmii"
    "xmonad" ];

in

{
  options = {

    services.xserver.windowManager = {

      enable = mkOption {
        type    = with types; listOf (enum wms);
        default = [];
        example = [ lib.head wms ];
        description = "Enabled window manager";
      };

      session = mkOption {
        internal = true;
        default = [];
        example = [{
          name = "wmii";
          start = "...";
        }];
        description = ''
          Internal option used to add some common line to window manager
          scripts before forwarding the value to the
          <varname>displayManager</varname>.
        '';
        apply = map (d: d // {
          manage = "window";
        });
      };

    };

  };

  config = {
    services.xserver.displayManager.session = cfg.session;
    services.xserver.enable = mkIf (cfg.enable != []) true;
  };
}
