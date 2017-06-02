{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager;

  # If desktop manager `d' isn't capable of setting a background and
  # the xserver is enabled, `feh' or `xsetroot' are used as a fallback.
  needBGCond = d: ! (d ? bgSupport && d.bgSupport) && xcfg.enable;

in

{

  options = {

    services.xserver.desktopManager = {

      select = mkOption {
        type = with types; listOf (enum [ ]);
        default = [];
        description = ''
          Select which desktop manager to use.
          Selecting a desktop manager will automatically enable the X server and a default display manager.
          The First item in the list will be made the default window manager.
        '';
      };

      wallpaper = {
        mode = mkOption {
          type = types.enum [ "center" "fill" "max" "scale" "tile" ];
          default = "scale";
          example = "fill";
          description = ''
            The file <filename>~/.background-image</filename> is used as a background image.
            This option specifies the placement of this image onto your desktop.

            Possible values:
            <literal>center</literal>: Center the image on the background. If it is too small, it will be surrounded by a black border.
            <literal>fill</literal>: Like <literal>scale</literal>, but preserves aspect ratio by zooming the image until it fits. Either a horizontal or a vertical part of the image will be cut off.
            <literal>max</literal>: Like <literal>fill</literal>, but scale the image to the maximum size that fits the screen with black borders on one side.
            <literal>scale</literal>: Fit the file into the background without repeating it, cutting off stuff or using borders. But the aspect ratio is not preserved either.
            <literal>tile</literal>: Tile (repeat) the image in case it is too small for the screen.
          '';
        };

        combineScreens = mkOption {
          type = types.bool;
          default = false;
          description = ''
            When set to <literal>true</literal> the wallpaper will stretch across all screens.
            When set to <literal>false</literal> the wallpaper is duplicated to all screens.
          '';
        };
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
              if [ -e $HOME/.background-image ]; then
                ${pkgs.feh}/bin/feh --bg-${cfg.wallpaper.mode} ${optionalString cfg.wallpaper.combineScreens "--no-xinerama"} $HOME/.background-image
              else
                # Use a solid black background as fallback
                ${pkgs.xorg.xsetroot}/bin/xsetroot -solid black
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
    environment.systemPackages =
      mkIf cfg.session.needBGPackages [ pkgs.feh ]; # xsetroot via xserver.enable
  };

  imports = [
   # backward compatibility for pre extensible option types
   (mkMergedOptionModule
     (map
       (dm: [ "services" "xserver" "desktopManager" dm "enable" ])
       [ "elightenment" "gnome3" "kodi" "lumina" "lxqt" "plasma5" "xfce" "xterm" ])
     [ "services" "xserver" "desktopManager" "select" ]
     (config:
       filter (dm:
         (getAttrFromPath [ "services" "xserver" "desktopManager" dm "enable" ] config) == true
       ) [ "elightenment" "gnome3" "kodi" "lumina" "lxqt" "plasma5" "xfce" "xterm" ]))

    (mkRemovedOptionModule [ "services" "xserver" "desktopManager" "default" ]
      "The default desktop manager is the first item of the services.xserver.desktopManager.select list.")
  ];
}
