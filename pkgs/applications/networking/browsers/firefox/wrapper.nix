{ stdenv, lib, makeDesktopItem, makeWrapper, lndir, config, replace

## various stuff that can be plugged in
, flashplayer, hal-flash
, MPlayerPlugin, ffmpeg, xorg, libpulseaudio, libcanberra-gtk2, libglvnd
, jrePlugin, adoptopenjdk-icedtea-web
, bluejeans, djview4, adobe-reader
, google_talk_plugin, fribid, gnome3/*.gnome-shell*/
, browserpass, chrome-gnome-shell, uget-integrator, plasma-browser-integration, bukubrow
, tridactyl-native
, udev
, kerberos
}:

## configurability of the wrapper itself

browser:

let
  wrapper = {
    browserName ? browser.browserName or (lib.getName browser)
  , pname ? browserName
  , version ? lib.getVersion browser
  , desktopName ? # browserName with first letter capitalized
    (lib.toUpper (lib.substring 0 1 browserName) + lib.substring 1 (-1) browserName)
  , nameSuffix ? ""
  , icon ? browserName
  , extraPlugins ? []
  , extraNativeMessagingHosts ? []
  , gdkWayland ? false
  , cfg ? config.${browserName} or {}

  , extraPrefs ? ""
  , extraExtensions ? [ ]
  , noNewProfileOnFFUpdate ? false
  , allowNonSigned ? false
  , disablePocket ? false
  , disableTelemetry ? true
  , disableDrmPlugin ? false
  , showPunycodeUrls ? true
  , enableUserchromeCSS ? false
  , disableFirefoxStudies ? true
  , disableFirefoxSync ? false
  , disableFirefoxUpdatePage ? true
  , useSystemCertificates ? true
  , dontCheckDefaultBrowser ? false
  # For more information about anti tracking (german website)
  # vist https://wiki.kairaven.de/open/app/firefox
  , activateAntiTracking ? true
  , disableFeedbackCommands ? true
  , disableDNSOverHTTPS ? true
  , disableGoogleSafebrowsing ? true
  , clearDataOnShutdown ? false
  , homepage ? "about:home"
  , enableDarkDevTools ? false
  # For more information about policies visit
  # https://github.com/mozilla/policy-templates#enterprisepoliciesenabled
  , extraPolicies ? {}
  }:

    assert gdkWayland -> (browser ? gtk3); # Can only use the wayland backend if gtk3 is being used

    let
      # If extraExtensions has been set disable manual extensions
      disableManualExtensions = if lib.count (x: true) extraExtensions > 0 then true else false;

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
          ++ lib.optional icedtea adoptopenjdk-icedtea-web
          ++ lib.optional (cfg.enableGoogleTalkPlugin or false) google_talk_plugin
          ++ lib.optional (cfg.enableFriBIDPlugin or false) fribid
          ++ lib.optional (cfg.enableGnomeExtensions or false) gnome3.gnome-shell
          ++ lib.optional (cfg.enableBluejeans or false) bluejeans
          ++ lib.optional (cfg.enableAdobeReader or false) adobe-reader
          ++ extraPlugins
        );
      nativeMessagingHosts =
        ([ ]
          ++ lib.optional (cfg.enableBrowserpass or false) (lib.getBin browserpass)
          ++ lib.optional (cfg.enableBukubrow or false) bukubrow
          ++ lib.optional (cfg.enableTridactylNative or false) tridactyl-native
          ++ lib.optional (cfg.enableGnomeExtensions or false) chrome-gnome-shell
          ++ lib.optional (cfg.enableUgetIntegrator or false) uget-integrator
          ++ lib.optional (cfg.enablePlasmaBrowserIntegration or false) plasma-browser-integration
          ++ extraNativeMessagingHosts
        );
      libs =   lib.optional stdenv.isLinux udev
            ++ lib.optional ffmpegSupport ffmpeg
            ++ lib.optional gssSupport kerberos
            ++ lib.optional gdkWayland libglvnd
            ++ lib.optionals (cfg.enableQuakeLive or false)
            (with xorg; [ stdenv.cc libX11 libXxf86dga libXxf86vm libXext libXt alsaLib zlib ])
            ++ lib.optional (enableAdobeFlash && (cfg.enableAdobeFlashDRM or false)) hal-flash
            ++ lib.optional (config.pulseaudio or true) libpulseaudio;
      gtk_modules = [ libcanberra-gtk2 ];

      enterprisePolicies =
      {
        policies = {
          DisableAppUpdate = true;
        } // lib.optionalAttrs disableManualExtensions (
        {
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
            ) {} extraExtensions;
          }
      ) // lib.optionalAttrs noNewProfileOnFFUpdate (
        {
          LegacyProfiles = true;
        }
      ) // lib.optionalAttrs disableFirefoxUpdatePage (
        {
          OverridePostUpdatePage = "";
        }
      ) // lib.optionalAttrs disablePocket (
        {
          DisablePocket = true;
        }
      ) // lib.optionalAttrs disableTelemetry (
        {
          DisableTelemetry = true;
        }
      ) // lib.optionalAttrs disableFirefoxStudies (
        {
          DisableFirefoxStudies = true;
        }
      ) // lib.optionalAttrs disableFirefoxSync (
        {
          DisableFirefoxAccounts = true;
        }
      ) // lib.optionalAttrs useSystemCertificates (
        {
          # Disable useless firefox certificate store
          Certificates = {
            ImportEnterpriseRoots = true;
          };
        }
      ) // lib.optionalAttrs (
        if lib.count (x: true) extraExtensions > 0 then true else false) (
        {
          # Don't try to update nix installed addons
          DisableSystemAddonUpdate = true;

          # But update manually installed addons
          ExtensionUpdate = false;
        }
      ) // lib.optionalAttrs dontCheckDefaultBrowser (
        {
          DontCheckDefaultBrowser = true;
        }
      )// lib.optionalAttrs disableDNSOverHTTPS (
        {
          DNSOverHTTPS = {
            Enabled = false;
          };
        }
      ) // lib.optionalAttrs clearDataOnShutdown (
        {
          SanitizeOnShutdown = true;
        }
      ) // lib.optionalAttrs disableFeedbackCommands (
        {
          DisableFeedbackCommands = true;
        }
      ) // lib.optionalAttrs ( if homepage == "" then false else true) (
        {
          Homepage = {
            URL = homepage;
            Locked = true;
          };
        }
      ) // extraPolicies ;} ;


      extensions = builtins.map (a:
        if ! (builtins.hasAttr "signed" a) || ! (builtins.isBool a.signed) then
          throw "Addon ${a.pname} needs boolean attribute 'signed' "
        else if ! (builtins.hasAttr "extid" a) || ! (builtins.isString a.extid) then
          throw "Addon ${a.pname} needs a string attribute 'extid'"
        else if a.signed == false && !allowNonSigned then
          throw "Disable signature checking in firefox if you want ${a.pname} addon"
        else  a
      ) extraExtensions;

      policiesJson = builtins.toFile "policies.json"
        (builtins.toJSON enterprisePolicies);

      mozillaCfg = builtins.toFile "mozilla.cfg" ''
// First line must be a comment

        // Remove default top sites
        lockPref("browser.newtabpage.pinned", "");
        lockPref("browser.newtabpage.activity-stream.default.sites", "");

        // Deactivate first run homepage
        lockPref("browser.startup.firstrunSkipsHomepage", false);

        // If true, don't show the privacy policy tab on first run
        lockPref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);

        ${
          if enableUserchromeCSS == true then
          ''
            lockPref("toolkit.legacyUserProfileCustomizations.stylesheets", "true");
          ''
          else
          ""
        }

        ${
          if enableDarkDevTools == true then
          ''
            //TODO: activeThemeID does not work. Enterprise Policies seem to
            // have an option for that
            // lockPref("extensions.activeThemeID","firefox-compact-dark@mozilla.org");
            lockPref("devtools.theme","dark");
          ''
          else
            ""
        }

        ${
          if allowNonSigned == true then
          ''
            lockPref("xpinstall.signatures.required", false);
          ''
          else
            ""
        }

       ${
        if showPunycodeUrls == true then
          ''
            lockPref("network.IDN_show_punycode", true);
          ''
          else
            ""
        }

        ${
          if disableManualExtensions == true then
          ''
            lockPref("extensions.getAddons.showPane", false);
            lockPref("extensions.htmlaboutaddons.recommendations.enabled", false);
            lockPref("app.update.auto", false);
            ''
          else
            ""
        }

        ${
          if disableDrmPlugin == true then
          ''
            lockPref("media.gmp-gmpopenh264.enabled", false);
            lockPref("media.gmp-widevinecdm.enabled", false);
            ''
          else
            ""
        }

        ${
          if activateAntiTracking == true then
            ''
              // Tracking
              lockPref("browser.send_pings", false);
              lockPref("browser.send_pings.require_same_host", true);
              lockPref("network.dns.disablePrefetch", true);
              lockPref("browser.contentblocking.trackingprotection.control-center.ui.enabled", false);
              lockPref("browser.search.geoip.url", "");
              lockPref("privacy.firstparty.isolate",  true);
              lockPref("privacy.userContext.enabled", true);
              lockPref("privacy.userContext.ui.enabled", true);
              lockPref("privacy.firstparty.isolate.restrict_opener_access", false);
              lockPref("network.http.referer.XOriginPolicy", 1);
              lockPref("network.http.referer.hideOnionSource", true);
              lockPref(" privacy.spoof_english", true);

              // This option is currently not usable because of bug:
              // https://bugzilla.mozilla.org/show_bug.cgi?id=1557620
              lockPref("privacy.resistFingerprinting", true);
            ''
            else ""
        }
        ${
          if disableTelemetry == true then
            ''
              // Telemetry
              lockPref("browser.newtabpage.activity-stream.feeds.telemetry", false);
              lockPref("browser.ping-centre.telemetry", false);
              lockPref("devtools.onboarding.telemetry.logged", false);
              lockPref("toolkit.telemetry.archive.enabled", false);
              lockPref("toolkit.telemetry.bhrPing.enabled", false);
              lockPref("toolkit.telemetry.enabled", false);
              lockPref("toolkit.telemetry.firstShutdownPing.enabled", false);
              lockPref("toolkit.telemetry.hybridContent.enabled", false);
              lockPref("toolkit.telemetry.newProfilePing.enabled", false);
              lockPref("toolkit.telemetry.shutdownPingSender.enabled", false);
              lockPref("toolkit.telemetry.reportingpolicy.firstRun", false);
              lockPref("dom.push.enabled", false);
              lockPref("browser.newtabpage.activity-stream.feeds.snippets", false);
              lockPref("security.ssl.errorReporting.enabled", false);
            ''
          else ""
        }

       ${
          if disableGoogleSafebrowsing == true then
          ''
            // Google data sharing
            lockPref("browser.safebrowsing.blockedURIs.enabled", false);
            lockPref("browser.safebrowsing.downloads.enabled", false);
            lockPref("browser.safebrowsing.malware.enabled", false);
            lockPref("browser.safebrowsing.passwords.enabled", false);
            lockPref("browser.safebrowsing.provider.google4.dataSharing.enabled", false);
            lockPref("browser.safebrowsing.malware.enabled", false);
            lockPref("browser.safebrowsing.phishing.enabled", false);
            lockPref("browser.safebrowsing.provider.mozilla.gethashURL", "");
            lockPref("browser.safebrowsing.provider.mozilla.updateURL", "");
          ''
          else ""
       }

        // User customization
        ${extraPrefs}
      '';
    in stdenv.mkDerivation {
      inherit pname version;

      desktopItem = makeDesktopItem {
        name = browserName;
        exec = "${browserName}${nameSuffix} %U";
        inherit icon;
        comment = "";
        desktopName = "${desktopName}${nameSuffix}${lib.optionalString gdkWayland " (Wayland)"}";
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


        # Link the runtime. The executable itself has to be copied,
        # because it will resolve paths relative to its true location.
        # Any symbolic links have to be replicated as well.
        cd "${browser}"
        find . -type d -exec mkdir -p "$out"/{} \;

        find . -type f \( -not -name "${browserName}" \) -exec ln -sT "${browser}"/{} "$out"/{} \;

        find . -type f -name "${browserName}" -print0 | while read -d $'\0' f; do
          cp -P --no-preserve=mode,ownership "${browser}/$f" "$out/$f"
          chmod a+rwx "$out/$f"
        done

        # fix links and absolute references
        cd "${browser}"

        find . -type l -print0 | while read -d $'\0' l; do
          target="$(readlink "$l" | ${replace}/bin/replace-literal -es -- "${browser}" "$out")"
          ln -sfT "$target" "$out/$l"
        done

        # This will not patch binaries, only "text" files.
        # Its there for the wrapper mostly.
        cd "$out"
        ${replace}/bin/replace-literal -esfR -- "${browser}" "$out"

        # create the wrapper

        executablePrefix="$out${browser.execdir or "/bin"}"
        executablePath="$executablePrefix/${browserName}"

        if [ ! -x "$executablePath" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${browserName}'"
            exit 1
        fi

        if [ ! -L "$executablePath" ]
        then
          # Careful here, the file at executablePath may already be
          # a wrapper. That is why we postfix it with -old instead
          # of -wrapped.
          oldExe="$executablePrefix"/".${browserName}"-old
          mv "$executablePath" "$oldExe"
        else
          oldExe="$(readlink -v --canonicalize-existing "$executablePath")"
        fi

        if [ ! -x "${browser}${browser.execdir or "/bin"}/${browserName}" ]
        then
            echo "cannot find executable file \`${browser}${browser.execdir or "/bin"}/${browserName}'"
            exit 1
        fi



        makeWrapper "$oldExe" \
          "$out${browser.execdir or "/bin"}/${browserName}${nameSuffix}" \
            --suffix-each MOZ_PLUGIN_PATH ':' "$plugins" \
            --suffix LD_LIBRARY_PATH ':' "$libs" \
            --suffix-each GTK_PATH ':' "$gtk_modules" \
            --suffix-each LD_PRELOAD ':' "$(cat $(filterExisting $(addSuffix /extra-ld-preload $plugins)))" \
            --prefix-contents PATH ':' "$(filterExisting $(addSuffix /extra-bin-path $plugins))" \
            --suffix PATH ':' "$out${browser.execdir or "/bin"}" \
            --set MOZ_APP_LAUNCHER "${browserName}${nameSuffix}" \
            --set MOZ_SYSTEM_DIR "$out/lib/mozilla" \
            --set SNAP_NAME "firefox" \
            --set MOZ_LEGACY_PROFILES 1 \
            --set MOZ_ALLOW_DOWNGRADE 1 \
            ${lib.optionalString gdkWayland ''
              --set GDK_BACKEND "wayland" \
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

        mkdir -p $out/lib/mozilla
        for ext in ${toString nativeMessagingHosts}; do
            lndir -silent $ext/lib/mozilla $out/lib/mozilla
        done

        # For manpages, in case the program supplies them
        mkdir -p $out/nix-support
        echo ${browser} > $out/nix-support/propagated-user-env-packages

        # user customization
        mkdir -p $out/lib/firefox

        # creating policies.json
        mkdir -p "$out/lib/firefox/distribution"

        cat > "$out/lib/firefox/distribution/policies.json" < ${policiesJson}

        # preparing for autoconfig
        mkdir -p "$out/lib/firefox/defaults/pref"

        cat > "$out/lib/firefox/defaults/pref/autoconfig.js" <<EOF
          pref("general.config.filename", "mozilla.cfg");
          pref("general.config.obscure_value", 0);
        EOF

        cat > "$out/lib/firefox/mozilla.cfg" < ${mozillaCfg}

        mkdir -p $out/lib/firefox/distribution/extensions

        for i in ${toString extensions}; do
          ln -s -t $out/lib/firefox/distribution/extensions $i/*
        done
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
