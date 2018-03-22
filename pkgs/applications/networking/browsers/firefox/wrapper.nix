{ stdenv, lib, makeDesktopItem, makeWrapper, lndir, config

## various stuff that can be plugged in
, flashplayer, hal-flash
, MPlayerPlugin, ffmpeg, gst_all, xorg, libpulseaudio, libcanberra-gtk2
, jrePlugin, icedtea_web
, trezor-bridge, bluejeans, djview4, adobe-reader
, google_talk_plugin, fribid, gnome3/*.gnome-shell*/
, esteidfirefoxplugin
, vlc_npapi
, browserpass, chrome-gnome-shell
, libudev
, kerberos
}:

## configurability of the wrapper itself

browser:

let
  wrapper =
    { browserName ? browser.browserName or (builtins.parseDrvName browser.name).name
    , name ? (browserName + "-" + (builtins.parseDrvName browser.name).version)
    , desktopName ? # browserName with first letter capitalized
      (lib.toUpper (lib.substring 0 1 browserName) + lib.substring 1 (-1) browserName)
    , nameSuffix ? ""
    , icon ? browserName
    , extraPlugins ? []
    , extraNativeMessagingHosts ? []
    }:

    let
      cfg = stdenv.lib.attrByPath [ browserName ] {} config;
      enableAdobeFlash = cfg.enableAdobeFlash or false;
      ffmpegSupport = browser.ffmpegSupport or false;
      gssSupport = browser.gssSupport or false;
      jre = cfg.jre or false;
      icedtea = cfg.icedtea or false;
      supportsJDK =
        stdenv.system == "i686-linux" ||
        stdenv.system == "x86_64-linux" ||
        stdenv.system == "armv7l-linux" ||
        stdenv.system == "aarch64-linux";

      plugins =
        assert !(jre && icedtea);
        ([ ]
          ++ lib.optional enableAdobeFlash flashplayer
          ++ lib.optional (cfg.enableDjvu or false) (djview4)
          ++ lib.optional (cfg.enableMPlayer or false) (MPlayerPlugin browser)
          ++ lib.optional (supportsJDK && jre && jrePlugin ? mozillaPlugin) jrePlugin
          ++ lib.optional icedtea icedtea_web
          ++ lib.optional (cfg.enableGoogleTalkPlugin or false) google_talk_plugin
          ++ lib.optional (cfg.enableFriBIDPlugin or false) fribid
          ++ lib.optional (cfg.enableGnomeExtensions or false) gnome3.gnome-shell
          ++ lib.optional (cfg.enableTrezor or false) trezor-bridge
          ++ lib.optional (cfg.enableBluejeans or false) bluejeans
          ++ lib.optional (cfg.enableAdobeReader or false) adobe-reader
          ++ lib.optional (cfg.enableEsteid or false) esteidfirefoxplugin
          ++ lib.optional (cfg.enableVLC or false) vlc_npapi
          ++ extraPlugins
        );
      nativeMessagingHosts =
        ([ ]
          ++ lib.optional (cfg.enableBrowserpass or false) browserpass
          ++ lib.optional (cfg.enableGnomeExtensions or false) chrome-gnome-shell
          ++ extraNativeMessagingHosts
        );
      libs = (if ffmpegSupport then [ ffmpeg ] else with gst_all; [ gstreamer gst-plugins-base ])
            ++ lib.optional gssSupport kerberos
            ++ lib.optionals (cfg.enableQuakeLive or false)
            (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib libudev ])
            ++ lib.optional (enableAdobeFlash && (cfg.enableAdobeFlashDRM or false)) hal-flash
            ++ lib.optional (config.pulseaudio or true) libpulseaudio;
      gst-plugins = with gst_all; [ gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-ffmpeg ];
      gtk_modules = [ libcanberra-gtk2 ];

    in stdenv.mkDerivation {
      inherit name;

      desktopItem = makeDesktopItem {
        name = browserName;
        exec = "${browserName}${nameSuffix} %U";
        inherit icon;
        comment = "";
        desktopName = "${desktopName}${nameSuffix}";
        genericName = "Web Browser";
        categories = "Application;Network;WebBrowser;";
        mimeType = stdenv.lib.concatStringsSep ";" [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
      };

      buildInputs = [makeWrapper]
        ++ lib.optional (!ffmpegSupport) gst-plugins
        ++ lib.optional (browser ? gtk3) browser.gtk3;

      buildCommand = ''
        if [ ! -x "${browser}/bin/${browserName}" ]
        then
            echo "cannot find executable file \`${browser}/bin/${browserName}'"
            exit 1
        fi

        makeWrapper "$(readlink -v --canonicalize-existing "${browser}/bin/${browserName}")" \
            "$out/bin/${browserName}${nameSuffix}" \
            --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
            --suffix LD_LIBRARY_PATH ':' "$libs" \
            --suffix-each GTK_PATH ':' "$gtk_modules" \
            --suffix-each LD_PRELOAD ':' "$(cat $(filterExisting $(addSuffix /extra-ld-preload $plugins)))" \
            --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
            --suffix PATH ':' "$out/bin" \
            --set MOZ_APP_LAUNCHER "${browserName}${nameSuffix}" \
            --set MOZ_SYSTEM_DIR "$out/lib/mozilla" \
            ${lib.optionalString (!ffmpegSupport)
                ''--prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"''
            + lib.optionalString (browser ? gtk3)
                ''--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
                  --suffix XDG_DATA_DIRS : '${gnome3.defaultIconTheme}/share'
                ''
            }

        if [ -e "${browser}/share/icons" ]; then
            mkdir -p "$out/share"
            ln -s "${browser}/share/icons" "$out/share/icons"
        else
            mkdir -p "$out/share/icons/hicolor/128x128/apps"
            ln -s "${browser}/lib/${browserName}-"*"/browser/icons/mozicon128.png" \
                "$out/share/icons/hicolor/128x128/apps/${browserName}.png"
        fi

        install -D -t $out/share/applications $desktopItem/share/applications/*

        mkdir -p $out/lib/mozilla
        for ext in ${toString nativeMessagingHosts}; do
            ${lndir}/bin/lndir -silent $ext/lib/mozilla $out/lib/mozilla
        done

        # For manpages, in case the program supplies them
        mkdir -p $out/nix-support
        echo ${browser} > $out/nix-support/propagated-user-env-packages
      '';

      preferLocalBuild = true;

      # Let each plugin tell us (through its `mozillaPlugin') attribute
      # where to find the plugin in its tree.
      plugins = map (x: x + x.mozillaPlugin) plugins;
      libs = lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;
      gtk_modules = map (x: x + x.gtkModule) gtk_modules;

      passthru = { unwrapped = browser; };

      disallowedRequisites = [ stdenv.cc ];

      meta = browser.meta // {
        description =
          browser.meta.description
          + " (with plugins: "
          + lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins))
          + ")";
        hydraPlatforms = [];
        priority = (browser.meta.priority or 0) - 1; # prefer wrapper over the package
      };
    };
in
  lib.makeOverridable wrapper
