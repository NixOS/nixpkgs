{ stdenv, lib, makeDesktopItem, makeWrapper, lndir, config
, xdg_utils

## various stuff that can be plugged in
, flashplayer, hal-flash
, ffmpeg, xorg, alsaLib, libpulseaudio, libcanberra-gtk2, libglvnd
, gnome3/*.gnome-shell*/
, browserpass, chrome-gnome-shell, uget-integrator, plasma5, bukubrow
, tridactyl-native
, fx_cast_bridge
, udev
, kerberos
, libva
, mesa # firefox wants gbm for drm+dmabuf
}:

## configurability of the wrapper itself

browser:

let
  wrapper =
    { browserName ? browser.browserName or (lib.getName browser)
    , pname ? browserName
    , version ? lib.getVersion browser
    , desktopName ? # browserName with first letter capitalized
      (lib.toUpper (lib.substring 0 1 browserName) + lib.substring 1 (-1) browserName)
    , nameSuffix ? ""
    , icon ? browserName
    , extraNativeMessagingHosts ? []
    , pkcs11Modules ? []
    , forceWayland ? false
    , useGlvnd ? true
    , cfg ? config.${browserName} or {}
    }:

    assert forceWayland -> (browser ? gtk3); # Can only use the wayland backend if gtk3 is being used

    let
      enableAdobeFlash = cfg.enableAdobeFlash or false;
      ffmpegSupport = browser.ffmpegSupport or false;
      gssSupport = browser.gssSupport or false;
      alsaSupport = browser.alsaSupport or false;

      plugins =
        let
          removed = lib.filter (a: builtins.hasAttr a cfg) [
            "enableVLC"
            "enableDjvu"
            "enableMPlayer"
            "jre"
            "icedtea"
            "enableGoogleTalkPlugin"
            "enableFriBIDPlugin"
            "enableBluejeans"
            "enableAdobeReader"
          ];
        in if removed != []
           then throw "Your configuration mentions ${lib.concatMapStringsSep ", " (p: browserName + "." + p) removed}. All plugin related options, except for the adobe flash player, have been removed, since Firefox from version 52 onwards no longer supports npapi plugins (see https://support.mozilla.org/en-US/kb/npapi-plugins)."
           else lib.optional enableAdobeFlash flashplayer;

      nativeMessagingHosts =
        ([ ]
          ++ lib.optional (cfg.enableBrowserpass or false) (lib.getBin browserpass)
          ++ lib.optional (cfg.enableBukubrow or false) bukubrow
          ++ lib.optional (cfg.enableTridactylNative or false) tridactyl-native
          ++ lib.optional (cfg.enableGnomeExtensions or false) chrome-gnome-shell
          ++ lib.optional (cfg.enableUgetIntegrator or false) uget-integrator
          ++ lib.optional (cfg.enablePlasmaBrowserIntegration or false) plasma5.plasma-browser-integration
          ++ lib.optional (cfg.enableFXCastBridge or false) fx_cast_bridge
          ++ extraNativeMessagingHosts
        );
      libs =   lib.optionals stdenv.isLinux [ udev libva mesa ]
            ++ lib.optional ffmpegSupport ffmpeg
            ++ lib.optional gssSupport kerberos
            ++ lib.optional useGlvnd libglvnd
            ++ lib.optionals (cfg.enableQuakeLive or false)
            (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ])
            ++ lib.optional (enableAdobeFlash && (cfg.enableAdobeFlashDRM or false)) hal-flash
            ++ lib.optional (config.pulseaudio or true) libpulseaudio
            ++ lib.optional alsaSupport alsaLib
            ++ pkcs11Modules;
      gtk_modules = [ libcanberra-gtk2 ];

    in stdenv.mkDerivation {
      inherit pname version;

      desktopItem = makeDesktopItem {
        name = browserName;
        exec = "${browserName}${nameSuffix} %U";
        inherit icon;
        comment = "";
        desktopName = "${desktopName}${nameSuffix}${lib.optionalString forceWayland " (Wayland)"}";
        genericName = "Web Browser";
        categories = "Network;WebBrowser;";
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
            --prefix PATH ':' "${xdg_utils}/bin" \
            --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
            --suffix PATH ':' "$out${browser.execdir or "/bin"}" \
            --set MOZ_APP_LAUNCHER "${browserName}${nameSuffix}" \
            --set MOZ_SYSTEM_DIR "$out/lib/mozilla" \
            --set MOZ_LEGACY_PROFILES 1 \
            --set MOZ_ALLOW_DOWNGRADE 1 \
            ${lib.optionalString forceWayland ''
              --set MOZ_ENABLE_WAYLAND "1" \
            ''}${lib.optionalString (browser ? gtk3)
                ''--prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
                  --suffix XDG_DATA_DIRS : '${gnome3.adwaita-icon-theme}/share'
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

        mkdir -p $out/lib/mozilla/native-messaging-hosts
        for ext in ${toString nativeMessagingHosts}; do
            ln -sLt $out/lib/mozilla/native-messaging-hosts $ext/lib/mozilla/native-messaging-hosts/*
        done

        mkdir -p $out/lib/mozilla/pkcs11-modules
        for ext in ${toString pkcs11Modules}; do
            ln -sLt $out/lib/mozilla/pkcs11-modules $ext/lib/mozilla/pkcs11-modules/*
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
