{ config, lib, pkgs, ... }:

with lib;

let

  xcfg = config.services.xserver;
  cfg = xcfg.desktopManager.kde4_next;
  xorg = pkgs.xorg;
  kde = pkgs.kde4_next;

  # Disable Nepomuk and Strigi by default.  As of KDE 4.7, they don't
  # really work very well (e.g. searching files often fails to find
  # files), segfault sometimes and consume significant resources.
  # They can be re-enabled in the KDE System Settings under "Desktop
  # Search".
  nepomukConfig = pkgs.writeTextFile
    { name = "nepomuk-config";
      destination = "/share/config/nepomukserverrc";
      text =
        ''
          [Basic Settings]
          Start Nepomuk=false

          [Service-nepomukstrigiservice]
          autostart=false
        '';
    };

  phononBackends = {
    gstreamer = [
      pkgs.phonon_backend_gstreamer
      pkgs.gst_all.gstPluginsBase
      pkgs.gst_all.gstPluginsGood
      pkgs.gst_all.gstPluginsUgly
      pkgs.gst_all.gstPluginsBad
      pkgs.gst_all.gstFfmpeg # for mp3 playback
      pkgs.gst_all.gstreamer # needed?
    ];

    vlc = [pkgs.phonon_backend_vlc];
  };

  phononBackendPackages = flip concatMap cfg.phononBackends
    (name: attrByPath [name] (throw "unknown phonon backend `${name}'") phononBackends);

in

{
  options = {

    services.xserver.desktopManager.kde4_next = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the KDE 4 desktop environment.";
      };

      phononBackends = mkOption {
        type = types.listOf types.str;
        default = ["gstreamer"];
        example = ["gstreamer" "vlc"];
        description = "Which phonon multimedia backend kde should use";
      };
    };

  };


  config = mkIf (xcfg.enable && cfg.enable) {

    # If KDE 4 is enabled, make it the default desktop manager (unless
    # overridden by the user's configuration).
    # !!! doesn't work yet ("Multiple definitions. Only one is allowed
    # for this option.")
    # services.xserver.desktopManager.default = mkOverride 900 "kde4";

    services.xserver.desktopManager.session = singleton
      { name = "kde4_next";
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
            exec ${kde.kdebase_workspace}/bin/startkde
          '';
      };

    security.setuidOwners = singleton
      { program = "kcheckpass";
        source = "${kde.kdebase_workspace}/lib/kde4/libexec/kcheckpass";
        owner = "root";
        group = "root";
        setuid = true;
      };

    environment.systemPackages =
        [ kde.kdelibs

          kde.kde_baseapps # Splitted kdebase
          kde.kde_workspace
          kde.kde_runtime
          kde.konsole
          kde.kate

          kde.kde_wallpapers # contains kdm's default background
          kde.oxygen_icons
          pkgs.virtuoso # to enable Nepomuk to find Virtuoso

          # Starts KDE's Polkit authentication agent.
          kde.polkit_kde_agent

          # Miscellaneous runtime dependencies.
          kde.qt4 # needed for qdbus
          pkgs.shared_mime_info
          xorg.xmessage # so that startkde can show error messages
          xorg.xset # used by startkde, non-essential
          xorg.xauth # used by kdesu
          pkgs.shared_desktop_ontologies # used by nepomuk
          pkgs.strigi # used by nepomuk
          pkgs.mysql # used by akonadi
        ]
      ++ lib.optional config.hardware.pulseaudio.enable kde.kmix  # Perhaps this should always be enabled
      ++ lib.optional config.hardware.bluetooth.enable kde.bluedevil
      ++ lib.optional config.networking.networkmanager.enable kde.networkmanagement
      ++ [ nepomukConfig ] ++ phononBackendPackages;

    environment.pathsToLink = [ "/share" ];

    environment.etc = singleton
      { source = "${pkgs.xkeyboard_config}/etc/X11/xkb";
        target = "X11/xkb";
      };

    # Enable helpful DBus services.
    services.udisks2.enable = true;
    services.upower.enable = config.powerManagement.enable;

    security.pam.services.kde = { allowNullPassword = true; };

  };

}
