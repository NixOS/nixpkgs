{ config, pkgs, ... }:

with pkgs.lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde4;
  xorg = pkgs.xorg;

in

{
  options = {

    services.xserver.desktopManager.kde4.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the KDE 4 desktop environment.";
    };

    environment.kdePackages = mkOption {
      default = [];
      example = "[ pkgs.kde4.kdesdk ]";
      type = types.list types.package;
      description = "This option is obsolete.  Please use <option>environment.systemPackages</option> instead.";
    };

  };

  
  config = mkIf (xcfg.enable && cfg.enable) {

    # If KDE 4 is enabled, make it the default desktop manager (unless
    # overriden by the user's configuration).
    # !!! doesn't work yet ("Multiple definitions. Only one is allowed
    # for this option.")
    # services.xserver.desktopManager.default = mkOverrideTemplate 900 "kde4";

    services.xserver.desktopManager.session = singleton
      { name = "kde4";
        bgSupport = true;
        start =
          ''
            # The KDE icon cache is supposed to update itself
            # automatically, but it uses the timestamp on the icon
            # theme directory as a trigger.  Since in Nix the
            # timestamp is always the same, this doesn't work.  So as
            # a workaround, nuke the icon cache on login.  This isn't
            # perfect, since it may require logging out after
            # installing new applications to update the cache.
            # See http://lists-archives.org/kde-devel/26175-what-when-will-icon-cache-refresh.html
            rm -fv $HOME/.kde/cache-*/icon-cache.kcache

            # Qt writes a weird ‘libraryPath’ line to
            # ~/.config/Trolltech.conf that causes the KDE plugin
            # paths of previous KDE invocations to be searched.
            # Obviously using mismatching KDE libraries is potentially
            # disastrous, so here we nuke references to the Nix store
            # in Trolltech.conf.  A better solution would be to stop
            # Qt from doing this wackiness in the first place.
            if [ -e $HOME/.config/Trolltech.conf ]; then
                sed -e '/nix\\store\|nix\/store/ d' -i $HOME/.config/Trolltech.conf
            fi

            # Start KDE.
            exec ${pkgs.kde4.kdebase_workspace}/bin/startkde
          '';
      };

    security.setuidOwners = singleton
      { program = "kcheckpass";
        source = "${pkgs.kde4.kdebase_workspace}/lib/kde4/libexec/kcheckpass";
        owner = "root";
        group = "root";
        setuid = true;
      };

    environment.systemPackages =
      (if pkgs.kde4 ? kdebase then
        # KDE <= 4.6
        [ # temporary workarounds
          pkgs.shared_desktop_ontologies 
          pkgs.strigi

          pkgs.kde4.kdelibs
          pkgs.kde4.kdebase
          pkgs.kde4.kdebase_runtime
          pkgs.kde4.kdebase_workspace
          pkgs.kde4.oxygen_icons
          pkgs.kde4.qt4 # needed for qdbus
          pkgs.shared_mime_info
          pkgs.gst_all.gstreamer
          pkgs.gst_all.gstPluginsBase
          pkgs.gst_all.gstPluginsGood
          pkgs.gst_all.gstFfmpeg # for mp3 playback
          xorg.xmessage # so that startkde can show error messages
          xorg.xset # used by startkde, non-essential
        ]
      else
        # KDE >= 4.7
        [ pkgs.kde4.kdelibs
          pkgs.kde4.kde_baseapps
          pkgs.kde4.kde_runtime
          pkgs.kde4.kde_workspace
          pkgs.kde4.kde_wallpapers # contains kdm's default background
          pkgs.kde4.oxygen_icons
          pkgs.kde4.konsole
          pkgs.kde4.kcolorchooser
          pkgs.kde4.ksnapshot
          pkgs.kde4.kate
          pkgs.kde4.okular
          pkgs.kde4.gwenview

          # Phonon backends.
          pkgs.kde4.phonon_backend_gstreamer
          pkgs.gst_all.gstPluginsBase

          # Miscellaneous runtime dependencies.
          pkgs.kde4.qt4 # needed for qdbus
          pkgs.shared_mime_info
          xorg.xmessage # so that startkde can show error messages
          xorg.xset # used by startkde, non-essential
          xorg.xauth # used by kdesu
        ]
      ) ++ config.environment.kdePackages;

    environment.pathsToLink = [ "/share" ];

    environment.etc = singleton
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      };

  };

}
