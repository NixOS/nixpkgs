{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager;

  # If desktop manager `d' isn't capable of setting a background and
  # the xserver is enabled, the `feh' program is used as a fallback.
  needBGCond = d: ! (d ? bgSupport && d.bgSupport) && xcfg.enable;

  dms = [ "enlightenment" "gnome3" "kde4" "kde5" "kodi" "xfce" "xterm" ];

in

{
  options = {

    services.xserver.desktopManager = {

      enable = mkOption {
        type    = with types; listOf (enum dms);
        default = [];
        example = [ (lib.head dms) ];
        description = "Enabled desktop manager";
      };

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

    };

  };

  config = {
    services.xserver.displayManager.session = cfg.session.list;
    services.xserver.enable = mkIf (cfg.enable != []) true;
    environment.systemPackages =
      mkIf cfg.session.needBGPackages [ pkgs.feh ];
  };
}
