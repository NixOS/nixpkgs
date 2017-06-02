{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager;
in

{

  options = {

    services.xserver.windowManager = {

      select = mkOption {
        type = with types; listOf (enum [ ]);
        default = [];
        description = ''
          Select which window manager to use.
          Selecting a window manager will automatically enable the X server.
          The First item in the list will be made the default window manager.
        '';
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
  };

  imports = [
   # backward compatibility with pre-extensible option types
   (let
      wms = [
        "2bwm" "afterstep" "awesome" "bspwm" "clfswm" "compiz" "dwm" "exwm" "fluxbox"
        "fvwm" "herbstluftwm" "i3" "icewm" "jwm" "metacity" "mwm" "notion" "openbox"
        "oroborus" "pekwm" "qtile" "ratpoison" "sawfish" "spectrwm" "stumpwm" "twm"
        "windowlab" "windowmaker" "wmii" "xmonad"
      ];
    in mkMergedOptionModule
     (map
       (wm: [ "services" "xserver" "windowManager" wm "enable" ])
       wms)
     [ "services" "xserver" "windowManager" "select" ]
     (config:
       filter (wm:
         (getAttrFromPath [ "services" "xserver" "windowManager" wm "enable" ] config) == true
       ) wms))
    (mkRemovedOptionModule [ "services" "xserver" "windowManager" "default" ] 
      "The default window manager is the first item of the services.xserver.windowManager.select list.")
  ];
}
