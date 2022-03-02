{ stdenv, lib, makeDesktopItem, makeWrapper, lndir, config
, replace, fetchurl, zip, unzip, jq, xdg-utils, writeText

## various stuff that can be plugged in
, ffmpeg, xorg, alsa-lib, libpulseaudio, libcanberra-gtk3, libglvnd, libnotify, opensc
, gnome/*.gnome-shell*/
, browserpass, chrome-gnome-shell, uget-integrator, plasma5Packages, bukubrow, pipewire
, tridactyl-native
, fx_cast_bridge
, udev
, libkrb5
, libva
, mesa # firefox wants gbm for drm+dmabuf
, cups
}:

## configurability of the wrapper itself

browser:

let
  wrapper =
    { applicationName ? browser.applicationName or (lib.getName browser)
    , pname ? applicationName
    , version ? lib.getVersion browser
    , desktopName ? # applicationName with first letter capitalized
      (lib.toUpper (lib.substring 0 1 applicationName) + lib.substring 1 (-1) applicationName)
    , nameSuffix ? ""
    , icon ? applicationName
    , wmClass ? null
    , extraNativeMessagingHosts ? []
    , pkcs11Modules ? []
    , forceWayland ? false
    , useGlvnd ? true
    , cfg ? config.${applicationName} or {}

    ## Following options are needed for extra prefs & policies
    # For more information about anti tracking (german website)
    # visit https://wiki.kairaven.de/open/app/firefox
    , extraPrefs ? ""
    , extraPrefsFiles ? []
    # For more information about policies visit
    # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
    , extraPolicies ? {}
    , extraPoliciesFiles ? []
    , libName ? browser.libName or "firefox" # Important for tor package or the like
    , nixExtensions ? null
    }:

    let
      ffmpegSupport = browser.ffmpegSupport or false;
      gssSupport = browser.gssSupport or false;
      alsaSupport = browser.alsaSupport or false;
      pipewireSupport = browser.pipewireSupport or false;
      # PCSC-Lite daemon (services.pcscd) also must be enabled for firefox to access smartcards
      smartcardSupport = cfg.smartcardSupport or false;

      nativeMessagingHosts =
        ([ ]
          ++ lib.optional (cfg.enableBrowserpass or false) (lib.getBin browserpass)
          ++ lib.optional (cfg.enableBukubrow or false) bukubrow
          ++ lib.optional (cfg.enableTridactylNative or false) tridactyl-native
          ++ lib.optional (cfg.enableGnomeExtensions or false) chrome-gnome-shell
          ++ lib.optional (cfg.enableUgetIntegrator or false) uget-integrator
          ++ lib.optional (cfg.enablePlasmaBrowserIntegration or false) plasma5Packages.plasma-browser-integration
          ++ lib.optional (cfg.enableFXCastBridge or false) fx_cast_bridge
          ++ extraNativeMessagingHosts
        );
      libs =   lib.optionals stdenv.isLinux [ udev libva mesa libnotify xorg.libXScrnSaver cups ]
            ++ lib.optional (pipewireSupport && lib.versionAtLeast version "83") pipewire
            ++ lib.optional ffmpegSupport ffmpeg
            ++ lib.optional gssSupport libkrb5
            ++ lib.optional useGlvnd libglvnd
            ++ lib.optionals (cfg.enableQuakeLive or false)
            (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsa-lib zlib ])
            ++ lib.optional (config.pulseaudio or true) libpulseaudio
            ++ lib.optional alsaSupport alsa-lib
            ++ lib.optional smartcardSupport opensc
            ++ pkcs11Modules;
      gtk_modules = [ libcanberra-gtk3 ];

      #########################
      #                       #
      #   EXTRA PREF CHANGES  #
      #                       #
      #########################
      policiesJson = writeText "policies.json" (builtins.toJSON enterprisePolicies);

      usesNixExtensions = nixExtensions != null;

      nameArray = builtins.map(a: a.name) (if usesNixExtensions then nixExtensions else []);

      # Check that every extension has a unqiue .name attribute
      # and an extid attribute
      extensions = if nameArray != (lib.unique nameArray) then
        throw "Firefox addon name needs to be unique"
      else if ! (lib.hasSuffix "esr" browser.name) then
        throw "Nix addons are only supported in Firefox ESR"
      else builtins.map (a:
        if ! (builtins.hasAttr "extid" a) then
        throw "nixExtensions has an invalid entry. Missing extid attribute. Please use fetchfirefoxaddon"
        else
        a
      ) (if usesNixExtensions then nixExtensions else []);

      enterprisePolicies =
      {
        policies = lib.optionalAttrs usesNixExtensions  {
          DisableAppUpdate = true;
        } //
        lib.optionalAttrs usesNixExtensions {
          ExtensionSettings = {
            "*" = {
                blocked_install_message = "You can't have manual extension mixed with nix extensions";
                installation_mode = "blocked";
              };

          } // lib.foldr (e: ret:
              ret // {
                "${e.extid}" = {
                  installation_mode = "allowed";
                };
              }
            ) {} extensions;
          } // lib.optionalAttrs usesNixExtensions {
            Extensions = {
              Install = lib.foldr (e: ret:
                ret ++ [ "${e.outPath}/${e.extid}.xpi" ]
                ) [] extensions;
            };
          } // lib.optionalAttrs smartcardSupport {
            SecurityDevices = {
              "OpenSC PKCS#11 Module" = "onepin-opensc-pkcs11.so";
            };
          }
        // extraPolicies;
      };

      mozillaCfg =  writeText "mozilla.cfg" ''
        // First line must be a comment

        // Disables addon signature checking
        // to be able to install addons that do not have an extid
        // Security is maintained because only user whitelisted addons
        // with a checksum can be installed
        ${ lib.optionalString usesNixExtensions ''lockPref("xpinstall.signatures.required", false)'' };
        ${extraPrefs}
      '';

      #############################
      #                           #
      #   END EXTRA PREF CHANGES  #
      #                           #
      #############################

    in stdenv.mkDerivation {
      inherit pname version;

      desktopItem = makeDesktopItem {
        name = applicationName;
        exec = "${applicationName}${nameSuffix} %U";
        inherit icon;
        desktopName = "${desktopName}${nameSuffix}${lib.optionalString forceWayland " (Wayland)"}";
        genericName = "Web Browser";
        categories = [ "Network" "WebBrowser" ];
        mimeTypes = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ftp"
        ];
        startupWMClass = wmClass;
      };

      nativeBuildInputs = [ makeWrapper lndir replace jq ];
      buildInputs = [ browser.gtk3 ];


      buildCommand = lib.optionalString stdenv.isDarwin ''
        mkdir -p $out/Applications
        cp -R --no-preserve=mode,ownership ${browser}/Applications/${applicationName}.app $out/Applications
        rm -f $out${browser.execdir or "/bin"}/${applicationName}
      '' + ''
        if [ ! -x "${browser}${browser.execdir or "/bin"}/${applicationName}" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${applicationName}'"
            exit 1
        fi

        #########################
        #                       #
        #   EXTRA PREF CHANGES  #
        #                       #
        #########################
        # Link the runtime. The executable itself has to be copied,
        # because it will resolve paths relative to its true location.
        # Any symbolic links have to be replicated as well.
        cd "${browser}"
        find . -type d -exec mkdir -p "$out"/{} \;

        find . -type f \( -not -name "${applicationName}" \) -exec ln -sT "${browser}"/{} "$out"/{} \;

        find . -type f \( -name "${applicationName}" -o -name "${applicationName}-bin" \) -print0 | while read -d $'\0' f; do
          cp -P --no-preserve=mode,ownership --remove-destination "${browser}/$f" "$out/$f"
          chmod a+rwx "$out/$f"
        done

        # fix links and absolute references
        cd "${browser}"

        find . -type l -print0 | while read -d $'\0' l; do
          target="$(readlink "$l" | replace-literal -es -- "${browser}" "$out")"
          ln -sfT "$target" "$out/$l"
        done

        # This will not patch binaries, only "text" files.
        # Its there for the wrapper mostly.
        cd "$out"
        replace-literal -esfR -- "${browser}" "$out"

        # create the wrapper

        executablePrefix="$out${browser.execdir or "/bin"}"
        executablePath="$executablePrefix/${applicationName}"

        if [ ! -x "$executablePath" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${applicationName}'"
            exit 1
        fi

        if [ ! -L "$executablePath" ]
        then
          # Careful here, the file at executablePath may already be
          # a wrapper. That is why we postfix it with -old instead
          # of -wrapped.
          oldExe="$executablePrefix"/".${applicationName}"-old
          mv "$executablePath" "$oldExe"
        else
          oldExe="$(readlink -v --canonicalize-existing "$executablePath")"
        fi

        if [ ! -x "${browser}${browser.execdir or "/bin"}/${applicationName}" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${applicationName}'"
            exit 1
        fi

        makeWrapper "$oldExe" \
          "$out${browser.execdir or "/bin"}/${applicationName}${nameSuffix}" \
            --prefix LD_LIBRARY_PATH ':' "$libs" \
            --suffix-each GTK_PATH ':' "$gtk_modules" \
            --prefix PATH ':' "${xdg-utils}/bin" \
            --suffix PATH ':' "$out${browser.execdir or "/bin"}" \
            --set MOZ_APP_LAUNCHER "${applicationName}${nameSuffix}" \
            --set MOZ_SYSTEM_DIR "$out/lib/mozilla" \
            --set MOZ_LEGACY_PROFILES 1 \
            --set MOZ_ALLOW_DOWNGRADE 1 \
            --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
            --suffix XDG_DATA_DIRS : '${gnome.adwaita-icon-theme}/share' \
            ${lib.optionalString forceWayland ''
              --set MOZ_ENABLE_WAYLAND "1" \
            ''}
        #############################
        #                           #
        #   END EXTRA PREF CHANGES  #
        #                           #
        #############################

        if [ -e "${browser}/share/icons" ]; then
            mkdir -p "$out/share"
            ln -s "${browser}/share/icons" "$out/share/icons"
        else
            for res in 16 32 48 64 128; do
            mkdir -p "$out/share/icons/hicolor/''${res}x''${res}/apps"
            icon=$( find "${browser}/lib/" -name "default''${res}.png" )
              if [ -e "$icon" ]; then ln -s "$icon" \
                "$out/share/icons/hicolor/''${res}x''${res}/apps/${applicationName}.png"
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


        #########################
        #                       #
        #   EXTRA PREF CHANGES  #
        #                       #
        #########################
        # user customization
        mkdir -p $out/lib/${libName}

        # creating policies.json
        mkdir -p "$out/lib/${libName}/distribution"

        POL_PATH="$out/lib/${libName}/distribution/policies.json"
        rm -f "$POL_PATH"
        cat ${policiesJson} >> "$POL_PATH"

        extraPoliciesFiles=(${builtins.toString extraPoliciesFiles})
        for extraPoliciesFile in "''${extraPoliciesFiles[@]}"; do
          jq -s '.[0] + .[1]' "$POL_PATH" $extraPoliciesFile > .tmp.json
          mv .tmp.json "$POL_PATH"
        done

        # preparing for autoconfig
        mkdir -p "$out/lib/${libName}/defaults/pref"

        echo 'pref("general.config.filename", "mozilla.cfg");' > "$out/lib/${libName}/defaults/pref/autoconfig.js"
        echo 'pref("general.config.obscure_value", 0);' >> "$out/lib/${libName}/defaults/pref/autoconfig.js"

        cat > "$out/lib/${libName}/mozilla.cfg" < ${mozillaCfg}

        extraPrefsFiles=(${builtins.toString extraPrefsFiles})
        for extraPrefsFile in "''${extraPrefsFiles[@]}"; do
          cat "$extraPrefsFile" >> "$out/lib/${libName}/mozilla.cfg"
        done

        mkdir -p $out/lib/${libName}/distribution/extensions

        #############################
        #                           #
        #   END EXTRA PREF CHANGES  #
        #                           #
        #############################
      '';

      preferLocalBuild = true;

      libs = lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;
      gtk_modules = map (x: x + x.gtkModule) gtk_modules;

      passthru = { unwrapped = browser; };

      disallowedRequisites = [ stdenv.cc ];

      meta = browser.meta // {
        description = browser.meta.description;
        hydraPlatforms = [];
        priority = (browser.meta.priority or 0) - 1; # prefer wrapper over the package
      };
    };
in lib.makeOverridable wrapper
