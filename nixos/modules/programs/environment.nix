# This module defines a standard configuration for NixOS global environment.

# Most of the stuff here should probably be moved elsewhere sometime.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.environment;

in

{

  config = {

    environment.variables =
      { LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
        LOCATE_PATH = "/var/cache/locatedb";
        NIXPKGS_CONFIG = "/etc/nix/nixpkgs-config.nix";
        NIX_PATH =
          [ "/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixpkgs=/etc/nixos/nixpkgs"
            "nixos-config=/etc/nixos/configuration.nix"
          ];
        PAGER = "less -R";
        EDITOR = "nano";
      };

    environment.profiles =
      [ "$HOME/.nix-profile"
        "/nix/var/nix/profiles/default"
        "/run/current-system/sw"
      ];

    # !!! fix environment.profileVariables definition and then move
    # most of these elsewhere
    environment.profileVariables = (i:
      { PATH = [ "${i}/bin" "${i}/sbin" "${i}/lib/kde4/libexec" ];
        MANPATH = [ "${i}/man" "${i}/share/man" ];
        INFOPATH = [ "${i}/info" "${i}/share/info" ];
        PKG_CONFIG_PATH = [ "${i}/lib/pkgconfig" ];
        TERMINFO_DIRS = [ "${i}/share/terminfo" ];
        PERL5LIB = [ "${i}/lib/perl5/site_perl" ];
        ALSA_PLUGIN_DIRS = [ "${i}/lib/alsa-lib" ];
        GST_PLUGIN_PATH = [ "${i}/lib/gstreamer-0.10" ];
        KDEDIRS = [ "${i}" ];
        STRIGI_PLUGIN_PATH = [ "${i}/lib/strigi/" ];
        QT_PLUGIN_PATH = [ "${i}/lib/qt4/plugins" "${i}/lib/kde4/plugins" ];
        QTWEBKIT_PLUGIN_PATH = [ "${i}/lib/mozilla/plugins/" ];
        GTK_PATH = [ "${i}/lib/gtk-2.0" ];
        XDG_CONFIG_DIRS = [ "${i}/etc/xdg" ];
        XDG_DATA_DIRS = [ "${i}/share" ];
        MOZ_PLUGIN_PATH = [ "${i}/lib/mozilla/plugins" ];
      });

    environment.extraInit =
      ''
         # reset TERM with new TERMINFO available (if any)
         export TERM=$TERM

         unset ASPELL_CONF
         for i in ${concatStringsSep " " (reverseList cfg.profiles)} ; do
           if [ -d "$i/lib/aspell" ]; then
             export ASPELL_CONF="dict-dir $i/lib/aspell"
           fi
         done

         export NIX_USER_PROFILE_DIR="/nix/var/nix/profiles/per-user/$USER"
         export NIX_PROFILES="${concatStringsSep " " (reverseList cfg.profiles)}"
      '';

  };

}
