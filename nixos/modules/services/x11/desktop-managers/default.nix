{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager;

  # Whether desktop manager `d' is capable of setting a background.
  # If it isn't, the `feh' program is used as a fallback.
  needBGCond = d: ! (d ? bgSupport && d.bgSupport);

in

{
  # Note: the order in which desktop manager modules are imported here
  # determines the default: later modules (if enabled) are preferred.
  # E.g., if KDE is enabled, it supersedes xterm.
  imports = [ ./none.nix ./xterm.nix ./xfce.nix ./gnome.nix ./kde4.nix ./e17.nix ];

  options = {

    services.xserver.desktopManager = {

      session = mkOption {
        internal = true;
        default = [];
        example = singleton
          { name = "kde";
            bgSupport = true;
            start = "...";
          };
        description = ''
          Internal option used to add some common line to desktop manager
          scripts before forwarding the value to the
          <varname>displayManager</varname>.
        '';
        apply = list: {
          list = map (d: d // {
            manage = "desktop";
            start = d.start
            + optionalString (needBGCond d) ''
              if test -e $HOME/.background-image; then
                ${pkgs.feh}/bin/feh --bg-scale $HOME/.background-image
              fi
            '';
          }) list;
          needBGPackages = [] != filter needBGCond list;
        };
      };

      default = mkOption {
        type = types.str;
        default = "";
        example = "none";
        description = "Default desktop manager loaded if none have been chosen.";
        apply = defaultDM:
          if defaultDM == "" && cfg.session.list != [] then
            (head cfg.session.list).name
          else if any (w: w.name == defaultDM) cfg.session.list then
            defaultDM
          else
            throw "Default desktop manager ($(defaultDM)) not found.";
      };

    };

  };

  config = {
    services.xserver.displayManager.session = cfg.session.list;
    environment.x11Packages =
      mkIf cfg.session.needBGPackages [ pkgs.feh ];
  };
}
