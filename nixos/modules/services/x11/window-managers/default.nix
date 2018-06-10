{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager;
in

{
  imports = [
    ./2bwm.nix
    ./afterstep.nix
    ./bspwm.nix
    ./dwm.nix
    ./evilwm.nix
    ./exwm.nix
    ./fluxbox.nix
    ./fvwm.nix
    ./herbstluftwm.nix
    ./i3.nix
    ./jwm.nix
    ./metacity.nix
    ./mwm.nix
    ./openbox.nix
    ./pekwm.nix
    ./notion.nix
    ./ratpoison.nix
    ./sawfish.nix
    ./stumpwm.nix
    ./spectrwm.nix
    ./twm.nix
    ./windowmaker.nix
    ./wmii.nix
    ./xmonad.nix
    ./qtile.nix
    ./none.nix ];

  options = {

    services.xserver.windowManager = {

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

      default = mkOption {
        type = types.str;
        default = "none";
        example = "wmii";
        description = "Default window manager loaded if none have been chosen.";
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
