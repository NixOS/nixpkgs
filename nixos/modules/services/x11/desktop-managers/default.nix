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
  # Note: the order in which desktop manager modules are imported here
  # determines the default: later modules (if enabled) are preferred.
  # E.g., if Plasma 5 is enabled, it supersedes xterm.
  imports = [
    ./none.nix ./xterm.nix ./phosh.nix ./xfce.nix ./plasma5.nix ./lumina.nix
    ./lxqt.nix ./enlightenment.nix ./gnome.nix ./retroarch.nix ./kodi.nix
    ./mate.nix ./pantheon.nix ./surf-display.nix ./cde.nix
    ./cinnamon.nix
  ];

  options = {

    services.xserver.desktopManager = {

      wallpaper = {
        mode = mkOption {
          type = types.enum [ "center" "fill" "max" "scale" "tile" ];
          default = "scale";
          example = "fill";
          description = lib.mdDoc ''
            The file {file}`~/.background-image` is used as a background image.
            This option specifies the placement of this image onto your desktop.

            Possible values:
            `center`: Center the image on the background. If it is too small, it will be surrounded by a black border.
            `fill`: Like `scale`, but preserves aspect ratio by zooming the image until it fits. Either a horizontal or a vertical part of the image will be cut off.
            `max`: Like `fill`, but scale the image to the maximum size that fits the screen with black borders on one side.
            `scale`: Fit the file into the background without repeating it, cutting off stuff or using borders. But the aspect ratio is not preserved either.
            `tile`: Tile (repeat) the image in case it is too small for the screen.
          '';
        };

        combineScreens = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            When set to `true` the wallpaper will stretch across all screens.
            When set to `false` the wallpaper is duplicated to all screens.
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
        description = lib.mdDoc ''
          Internal option used to add some common line to desktop manager
          scripts before forwarding the value to the
          `displayManager`.
        '';
        apply = map (d: d // {
          manage = "desktop";
          start = d.start
          # literal newline to ensure d.start's last line is not appended to
          + optionalString (needBGCond d) ''

            if [ -e $HOME/.background-image ]; then
              ${pkgs.feh}/bin/feh --bg-${cfg.wallpaper.mode} ${optionalString cfg.wallpaper.combineScreens "--no-xinerama"} $HOME/.background-image
            fi
          '';
        });
      };

      default = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "none";
        description = lib.mdDoc ''
          **Deprecated**, please use [](#opt-services.xserver.displayManager.defaultSession) instead.

          Default desktop manager loaded if none have been chosen.
        '';
      };

    };

  };

  config.services.xserver.displayManager.session = cfg.session;
}
