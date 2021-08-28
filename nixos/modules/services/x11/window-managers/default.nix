{ config, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager;
in

{
  imports = [
    ./2bwm.nix
    ./afterstep.nix
    ./berry.nix
    ./bspwm.nix
    ./cwm.nix
    ./clfswm.nix
    ./dwm.nix
    ./e16.nix
    ./evilwm.nix
    ./exwm.nix
    ./fluxbox.nix
    ./fvwm.nix
    ./herbstluftwm.nix
    ./i3.nix
    ./jwm.nix
    ./leftwm.nix
    ./lwm.nix
    ./metacity.nix
    ./mwm.nix
    ./openbox.nix
    ./pekwm.nix
    ./notion.nix
    ./ratpoison.nix
    ./sawfish.nix
    ./smallwm.nix
    ./stumpwm.nix
    ./spectrwm.nix
    ./tinywm.nix
    ./twm.nix
    ./windowmaker.nix
    ./wmderland.nix
    ./wmii.nix
    ./xmonad.nix
    ./yeahwm.nix
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
        type = types.nullOr types.str;
        default = null;
        example = "wmii";
        description = ''
          <emphasis role="strong">Deprecated</emphasis>, please use <xref linkend="opt-services.xserver.displayManager.defaultSession"/> instead.

          Default window manager loaded if none have been chosen.
        '';
      };

    };

  };

  config = {
    services.xserver.displayManager.session = cfg.session;
  };
}
