# This module defines a standard configuration for NixOS global environment.

# Most of the stuff here should probably be moved elsewhere sometime.

{ config, lib, ... }:

with lib;

let

  cfg = config.environment;

in

{

  config = {

    environment.variables =
      { NIXPKGS_CONFIG = "/etc/nix/nixpkgs-config.nix";
        # note: many programs exec() this directly, so default options for less must not
        # be specified here; do so in the default value of programs.less.envVariables instead
        PAGER = mkDefault "less";
        EDITOR = mkDefault "nano";
        XDG_CONFIG_DIRS = [ "/etc/xdg" ]; # needs to be before profile-relative paths to allow changes through environment.etc
      };

    # since we set PAGER to this above, make sure it's installed
    programs.less.enable = true;

    environment.profiles = mkAfter
      [ "/nix/var/nix/profiles/default"
        "/run/current-system/sw"
      ];

    # TODO: move most of these elsewhere
    environment.profileRelativeSessionVariables =
      { PATH = [ "/bin" ];
        INFOPATH = [ "/info" "/share/info" ];
        KDEDIRS = [ "" ];
        QT_PLUGIN_PATH = [ "/lib/qt4/plugins" "/lib/kde4/plugins" ];
        QTWEBKIT_PLUGIN_PATH = [ "/lib/mozilla/plugins/" ];
        GTK_PATH = [ "/lib/gtk-2.0" "/lib/gtk-3.0" "/lib/gtk-4.0" ];
        XDG_CONFIG_DIRS = [ "/etc/xdg" ];
        XDG_DATA_DIRS = [ "/share" ];
        MOZ_PLUGIN_PATH = [ "/lib/mozilla/plugins" ];
        LIBEXEC_PATH = [ "/lib/libexec" ];
      };

    environment.pathsToLink = [ "/lib/gtk-2.0" "/lib/gtk-3.0" "/lib/gtk-4.0" ];

    environment.extraInit =
      ''
         export NIX_USER_PROFILE_DIR="/nix/var/nix/profiles/per-user/$USER"
         export NIX_PROFILES="${concatStringsSep " " (reverseList cfg.profiles)}"
      '';

  };

}
