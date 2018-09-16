{ stdenv, lib, makeDesktopItem, makeWrapper, lndir, config

## various stuff that can be plugged in
, flashplayer, hal-flash
, MPlayerPlugin, ffmpeg, xorg, libpulseaudio, libcanberra-gtk2
, jrePlugin, icedtea_web
, trezor-bridge, bluejeans, djview4, adobe-reader
, google_talk_plugin, fribid, gnome3/*.gnome-shell*/
, esteidfirefoxplugin
, browserpass, chrome-gnome-shell, uget-integrator, plasma-browser-integration, bukubrow
, udev
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
      cfg = config.${browserName} or {};
      enableAdobeFlash = cfg.enableAdobeFlash or false;
      ffmpegSupport = browser.ffmpegSupport or false;
      gssSupport = browser.gssSupport or false;
      jre = cfg.jre or false;
      icedtea = cfg.icedtea or false;
      supportsJDK =
        stdenv.hostPlatform.system == "i686-linux" ||
        stdenv.hostPlatform.system == "x86_64-linux" ||
        stdenv.hostPlatform.system == "armv7l-linux" ||
        stdenv.hostPlatform.system == "aarch64-linux";

      plugins =
        assert !(jre && icedtea);
        if builtins.hasAttr "enableVLC" cfg
        then throw "The option \"${browserName}.enableVLC\" has been removed since Firefox no longer supports npapi plugins"
        else
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
          ++ extraPlugins
        );
      nativeMessagingHosts =
        ([ ]
          ++ lib.optional (cfg.enableBrowserpass or false) (lib.getBin browserpass)
          ++ lib.optional (cfg.enableBukubrow or false) bukubrow
          ++ lib.optional (cfg.enableGnomeExtensions or false) chrome-gnome-shell
          ++ lib.optional (cfg.enableUgetIntegrator or false) uget-integrator
          ++ lib.optional (cfg.enablePlasmaBrowserIntegration or false) plasma-browser-integration
          ++ extraNativeMessagingHosts
        );
      libs =   lib.optional stdenv.isLinux udev
            ++ lib.optional ffmpegSupport ffmpeg
            ++ lib.optional gssSupport kerberos
            ++ lib.optionals (cfg.enableQuakeLive or false)
            (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ])
            ++ lib.optional (enableAdobeFlash && (cfg.enableAdobeFlashDRM or false)) hal-flash
            ++ lib.optional (config.pulseaudio or true) libpulseaudio;
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

      nativeBuildInputs = [ makeWrapper lndir ];
      buildInputs = lib.optional (browser ? gtk3) browser.gtk3;

      buildCommand = lib.optionalString stdenv.isDarwin ''
        mkdir -p $out/Applications
        cp -R --no-preserve=mode,ownership ${browser}/Applications/${browserName}.app $out/Applications
        rm -f $out${browser.execdir or "/bin"}/${browserName}
      '' + ''
        if [ ! -x "${browser}${browser.execdir or "/bin"}/${browserName}" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${browserName}'"
            exit 1
        fi

        makeWrapper "$(readlink -v --canonicalize-existing "${browser}${browser.execdir or "/bin"}/${browserName}")" \
          "$out${browser.execdir or "/bin"}/${browserName}${nameSuffix}" \
            --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
            --suffix LD_LIBRARY_PATH ':' "$libs" \
            --suffix-each GTK_PATH ':' "$gtk_modules" \
            --suffix-each LD_PRELOAD ':' "$(cat $(filterExisting $(addSuffix /extra-ld-preload $plugins)))" \
            --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
            --suffix PATH ':' "$out${browser.execdir or "/bin"}" \
            --set MOZ_APP_LAUNCHER "${browserName}${nameSuffix}" \
            --set MOZ_SYSTEM_DIR "$out/lib/mozilla" \
            ${lib.optionalString (browser ? gtk3)
                ''--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
                  --suffix XDG_DATA_DIRS : '${gnome3.defaultIconTheme}/share'
                ''
            }

        if [ -e "${browser}/share/icons" ]; then
            mkdir -p "$out/share"
            ln -s "${browser}/share/icons" "$out/share/icons"
        else
            for res in 16 32 48 64 128; do
            mkdir -p "$out/share/icons/hicolor/''${res}x''${res}/apps"
            icon=( "${browser}/lib/"*"/browser/chrome/icons/default/default''${res}.png" )
              if [ -e "$icon" ]; then ln -s "$icon" \
                "$out/share/icons/hicolor/''${res}x''${res}/apps/${browserName}.png"
              fi
            done
        fi

        install -D -t $out/share/applications $desktopItem/share/applications/*

        mkdir -p $out/lib/mozilla
        for ext in ${toString nativeMessagingHosts}; do
            lndir -silent $ext/lib/mozilla $out/lib/mozilla
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
