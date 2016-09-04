{ stdenv, lib, makeDesktopItem, makeWrapper, config

## various stuff that can be plugged in
, gnash, flashplayer, hal-flash
, MPlayerPlugin, gecko_mediaplayer, ffmpeg, gst_all, xorg, libpulseaudio, libcanberra
, supportsJDK, jrePlugin, icedtea_web
, trezor-bridge, bluejeans, djview4, adobe-reader
, google_talk_plugin, fribid, gnome3/*.gnome_shell*/
, esteidfirefoxplugin
, vlc_npapi
}:

## configurability of the wrapper itself
browser:
{ browserName ? browser.browserName or (builtins.parseDrvName browser.name).name
, name ? (browserName + "-" + (builtins.parseDrvName browser.name).version)
, desktopName ? # browserName with first letter capitalized
  (lib.toUpper (lib.substring 0 1 browserName) + lib.substring 1 (-1) browserName)
, nameSuffix ? ""
, icon ? browserName, libtrick ? true
}:

let
  cfg = stdenv.lib.attrByPath [ browserName ] {} config;
  enableAdobeFlash = cfg.enableAdobeFlash or false;
  enableGnash = cfg.enableGnash or false;
  ffmpegSupport = browser.ffmpegSupport or false;
  jre = cfg.jre or false;
  icedtea = cfg.icedtea or false;

  plugins =
     assert !(enableGnash && enableAdobeFlash);
     assert !(jre && icedtea);
     ([ ]
      ++ lib.optional enableGnash gnash
      ++ lib.optional enableAdobeFlash flashplayer
      ++ lib.optional (cfg.enableDjvu or false) (djview4)
      ++ lib.optional (cfg.enableMPlayer or false) (MPlayerPlugin browser)
      ++ lib.optional (cfg.enableGeckoMediaPlayer or false) gecko_mediaplayer
      ++ lib.optional (supportsJDK && jre && jrePlugin ? mozillaPlugin) jrePlugin
      ++ lib.optional icedtea icedtea_web
      ++ lib.optional (cfg.enableGoogleTalkPlugin or false) google_talk_plugin
      ++ lib.optional (cfg.enableFriBIDPlugin or false) fribid
      ++ lib.optional (cfg.enableGnomeExtensions or false) gnome3.gnome_shell
      ++ lib.optional (cfg.enableTrezor or false) trezor-bridge
      ++ lib.optional (cfg.enableBluejeans or false) bluejeans
      ++ lib.optional (cfg.enableAdobeReader or false) adobe-reader
      ++ lib.optional (cfg.enableEsteid or false) esteidfirefoxplugin
      ++ lib.optional (cfg.enableVLC or false) vlc_npapi
     );
  libs = (if ffmpegSupport then [ ffmpeg ] else with gst_all; [ gstreamer gst-plugins-base ])
         ++ lib.optionals (cfg.enableQuakeLive or false)
         (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ])
         ++ lib.optional (enableAdobeFlash && (cfg.enableAdobeFlashDRM or false)) hal-flash
         ++ lib.optional (config.pulseaudio or false) libpulseaudio;
  gst-plugins = with gst_all; [ gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-ffmpeg ];
  gtk_modules = [ libcanberra ];

in
stdenv.mkDerivation {
  inherit name;

  desktopItem = makeDesktopItem {
    name = browserName;
    exec = browserName + " %U";
    inherit icon;
    comment = "";
    desktopName = desktopName;
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

  buildInputs = [makeWrapper] ++ lib.optionals (!ffmpegSupport) gst-plugins;

  buildCommand = ''
    if [ ! -x "${browser}/bin/${browserName}" ]
    then
        echo "cannot find executable file \`${browser}/bin/${browserName}'"
        exit 1
    fi

    makeWrapper "${browser}/bin/${browserName}" \
        "$out/bin/${browserName}${nameSuffix}" \
        --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
        --suffix LD_LIBRARY_PATH ':' "$libs" \
        --suffix-each GTK_PATH ':' "$gtk_modules" \
        --suffix-each LD_PRELOAD ':' "$(cat $(filterExisting $(addSuffix /extra-ld-preload $plugins)))" \
        --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
        --set MOZ_OBJDIR "$(ls -d "${browser}/lib/${browserName}"*)" \
        ${lib.optionalString (!ffmpegSupport) ''--prefix GST_PLUGIN_SYSTEM_PATH : "$GST_PLUGIN_SYSTEM_PATH"''}

    ${ lib.optionalString libtrick
    ''
    libdirname="$(echo "${browser}/lib/${browserName}"*)"
    libdirbasename="$(basename "$libdirname")"
    mkdir -p "$out/lib/$libdirbasename"
    ln -s "$libdirname"/* "$out/lib/$libdirbasename"
    script_location="$(mktemp "$out/lib/$libdirbasename/${browserName}${nameSuffix}.XXXXXX")"
    mv "$out/bin/${browserName}${nameSuffix}" "$script_location"
    ln -s "$script_location" "$out/bin/${browserName}${nameSuffix}"
    ''
    }

    if [ -e "${browser}/share/icons" ]; then
        mkdir -p "$out/share"
        ln -s "${browser}/share/icons" "$out/share/icons"
    else
        mkdir -p "$out/share/icons/hicolor/128x128/apps"
        ln -s "$out/lib/$libdirbasename/browser/icons/mozicon128.png" \
            "$out/share/icons/hicolor/128x128/apps/${browserName}.png"
    fi

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications

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

  meta = browser.meta // {
    description =
      browser.meta.description
      + " (with plugins: "
      + lib.concatStrings (lib.intersperse ", " (map (x: x.name) plugins))
      + ")";
    hydraPlatforms = [];
    priority = (browser.meta.priority or 0) - 1; # prefer wrapper over the package
  };
}
