{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.xserver.windowManager;
in

{
  imports =
    [ ./compiz.nix
      ./openbox.nix
      ./metacity.nix
      ./none.nix
      ./twm.nix
      ./wmii.nix
      ./xmonad.nix
      ./i3.nix
      ./xbmc.nix
    ];

  options = {

    services.xserver.windowManager = {

      session = mkOption {
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

      default = mkOption {
        default = "none";
        example = "wmii";
        description = "Default window manager loaded if none have been chosen.";
        merge = mergeOneOption;
        apply = defaultWM:
          if any (w: w.name == defaultWM) cfg.session then
            defaultWM
          else
            throw "Default window manager (${defaultWM}) not found.";
      };

    };

  };

  config = {
    services.xserver.displayManager.session = cfg.session;
  };
}
