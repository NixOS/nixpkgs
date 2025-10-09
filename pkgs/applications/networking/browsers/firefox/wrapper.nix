{
  stdenv,
  lib,
  makeDesktopItem,
  makeWrapper,
  lndir,
  config,
  buildPackages,
  jq,
  xdg-utils,
  writeText,

  ## various stuff that can be plugged in
  ffmpeg,
  xorg,
  alsa-lib,
  libpulseaudio,
  libcanberra-gtk3,
  libglvnd,
  libnotify,
  opensc,
  adwaita-icon-theme,
  pipewire,
  udev,
  libkrb5,
  libva,
  libgbm,
  cups,
  pciutils,
  vulkan-loader,
  sndio,
  libjack2,
  speechd-minimal,
}:

## configurability of the wrapper itself

browser:

let
  isDarwin = stdenv.hostPlatform.isDarwin;
  wrapper =
    {
      applicationName ? browser.binaryName or (lib.getName browser), # Note: this is actually *binary* name and is different from browser.applicationName, which is *app* name!
      pname ? applicationName,
      version ? lib.getVersion browser,
      nameSuffix ? "",
      icon ? applicationName,
      wmClass ? applicationName,
      nativeMessagingHosts ? [ ],
      pkcs11Modules ? [ ],
      useGlvnd ? (!isDarwin),
      cfg ? config.${applicationName} or { },

      ## Following options are needed for extra prefs & policies
      # For more information about anti tracking (german website)
      # visit https://wiki.kairaven.de/open/app/firefox
      extraPrefs ? "",
      extraPrefsFiles ? [ ],
      # For more information about policies visit
      # https://mozilla.github.io/policy-templates/
      extraPolicies ? { },
      extraPoliciesFiles ? [ ],
      libName ? browser.libName or applicationName, # Important for tor package or the like
      nixExtensions ? null,
      hasMozSystemDirPatch ? (lib.hasPrefix "firefox" pname && !lib.hasSuffix "-bin" pname),
    }:

    let
      ffmpegSupport = browser.ffmpegSupport or false;
      gssSupport = browser.gssSupport or false;
      alsaSupport = browser.alsaSupport or false;
      pipewireSupport = browser.pipewireSupport or false;
      sndioSupport = browser.sndioSupport or false;
      jackSupport = browser.jackSupport or false;
      # PCSC-Lite daemon (services.pcscd) also must be enabled for firefox to access smartcards
      smartcardSupport = cfg.smartcardSupport or false;

      allNativeMessagingHosts = map lib.getBin nativeMessagingHosts;

      libs =
        lib.optionals stdenv.hostPlatform.isLinux (
          [
            udev
            libva
            libgbm
            libnotify
            xorg.libXScrnSaver
            cups
            pciutils
            vulkan-loader
          ]
          ++ lib.optional (cfg.speechSynthesisSupport or true) speechd-minimal
        )
        ++ lib.optional pipewireSupport pipewire
        ++ lib.optional ffmpegSupport ffmpeg
        ++ lib.optional gssSupport libkrb5
        ++ lib.optional useGlvnd libglvnd
        ++ lib.optionals (cfg.enableQuakeLive or false) (
          with xorg;
          [
            stdenv.cc
            libX11
            libXxf86dga
            libXxf86vm
            libXext
            libXt
            alsa-lib
            zlib
          ]
        )
        ++ lib.optional (config.pulseaudio or (!isDarwin)) libpulseaudio
        ++ lib.optional alsaSupport alsa-lib
        ++ lib.optional sndioSupport sndio
        ++ lib.optional jackSupport libjack2
        ++ lib.optional smartcardSupport opensc
        ++ pkcs11Modules
        ++ lib.optionals (!isDarwin) gtk_modules;
      gtk_modules = [ libcanberra-gtk3 ];

      # Darwin does not rename bundled binaries
      launcherName = "${applicationName}${lib.optionalString (!isDarwin) nameSuffix}";

      #########################
      #                       #
      #   EXTRA PREF CHANGES  #
      #                       #
      #########################
      policiesJson = writeText "policies.json" (builtins.toJSON enterprisePolicies);

      usesNixExtensions = nixExtensions != null;

      nameArray = map (a: a.name) (lib.optionals usesNixExtensions nixExtensions);

      # Check that every extension has a unique .name attribute
      # and an extid attribute
      extensions =
        if nameArray != (lib.unique nameArray) then
          throw "Firefox addon name needs to be unique"
        else if browser.requireSigning || !browser.allowAddonSideload then
          throw "Nix addons are only supported with signature enforcement disabled and addon sideloading enabled (eg. LibreWolf)"
        else
          map (
            a:
            if !(builtins.hasAttr "extid" a) then
              throw "nixExtensions has an invalid entry. Missing extid attribute. Please use fetchFirefoxAddon"
            else
              a
          ) (lib.optionals usesNixExtensions nixExtensions);

      enterprisePolicies = {
        policies = {
          DisableAppUpdate = true;
        }
        // lib.optionalAttrs usesNixExtensions {
          ExtensionSettings = {
            "*" = {
              blocked_install_message = "You can't have manual extension mixed with nix extensions";
              installation_mode = "blocked";
            };
          }
          // lib.foldr (
            e: ret:
            ret
            // {
              "${e.extid}" = {
                installation_mode = "allowed";
              };
            }
          ) { } extensions;

          Extensions = {
            Install = lib.foldr (e: ret: ret ++ [ "${e.outPath}/${e.extid}.xpi" ]) [ ] extensions;
          };
        }
        // lib.optionalAttrs smartcardSupport {
          SecurityDevices = {
            "OpenSC PKCS#11 Module" = "opensc-pkcs11.so";
          };
        }
        // extraPolicies;
      };

      mozillaCfg = ''
        // First line must be a comment

        // Disables addon signature checking
        // to be able to install addons that do not have an extid
        // Security is maintained because only user whitelisted addons
        // with a checksum can be installed
        ${lib.optionalString usesNixExtensions ''lockPref("xpinstall.signatures.required", false);''}
      '';

      #############################
      #                           #
      #   END EXTRA PREF CHANGES  #
      #                           #
      #############################

    in
    stdenv.mkDerivation (finalAttrs: {
      __structuredAttrs = true;
      inherit pname version;

      desktopItem = makeDesktopItem (
        {
          name = launcherName;
          exec = "${launcherName} --name ${wmClass} %U";
          inherit icon;
          desktopName = browser.applicationName;
          startupNotify = true;
          startupWMClass = wmClass;
          terminal = false;
        }
        // (
          if libName == "thunderbird" then
            {
              genericName = "Email Client";
              comment = "Read and write e-mails or RSS feeds, or manage tasks on calendars.";
              categories = [
                "Network"
                "Chat"
                "Email"
                "Feed"
                "GTK"
                "News"
              ];
              keywords = [
                "mail"
                "email"
                "e-mail"
                "messages"
                "rss"
                "calendar"
                "address book"
                "addressbook"
                "chat"
              ];
              mimeTypes = [
                "message/rfc822"
                "x-scheme-handler/mailto"
                "text/calendar"
                "text/x-vcard"
              ];
              actions = {
                profile-manager-window = {
                  name = "Profile Manager";
                  exec = "${launcherName} --ProfileManager";
                };
              };
            }
          else
            {
              genericName = "Web Browser";
              categories = [
                "Network"
                "WebBrowser"
              ];
              mimeTypes = [
                "text/html"
                "text/xml"
                "application/xhtml+xml"
                "application/vnd.mozilla.xul+xml"
                "x-scheme-handler/http"
                "x-scheme-handler/https"
              ];
              actions = {
                new-window = {
                  name = "New Window";
                  exec = "${launcherName} --new-window %U";
                };
                new-private-window = {
                  name = "New Private Window";
                  exec = "${launcherName} --private-window %U";
                };
                profile-manager-window = {
                  name = "Profile Manager";
                  exec = "${launcherName} --ProfileManager";
                };
              };
            }
        )
      );

      nativeBuildInputs = [
        makeWrapper
        lndir
        jq
      ];
      buildInputs = lib.optionals (!isDarwin) [ browser.gtk3 ];

      makeWrapperArgs = [
        "--prefix"
        "LD_LIBRARY_PATH"
        ":"
        "${finalAttrs.libs}"

        "--suffix"
        "PATH"
        ":"
        "${placeholder "out"}/bin"

        "--set"
        "MOZ_APP_LAUNCHER"
        launcherName

        "--set"
        "MOZ_LEGACY_PROFILES"
        "1"

        "--set"
        "MOZ_ALLOW_DOWNGRADE"
        "1"
      ]
      ++ lib.optionals (!isDarwin) [
        "--suffix"
        "GTK_PATH"
        ":"
        "${lib.concatStringsSep ":" finalAttrs.gtk_modules}"

        "--suffix"
        "XDG_DATA_DIRS"
        ":"
        "${adwaita-icon-theme}/share"

        "--set-default"
        "MOZ_ENABLE_WAYLAND"
        "1"

      ]
      ++ lib.optionals (!xdg-utils.meta.broken && !isDarwin) [
        # make xdg-open overridable at runtime
        "--suffix"
        "PATH"
        ":"
        "${lib.makeBinPath [ xdg-utils ]}"

      ]
      ++ lib.optionals hasMozSystemDirPatch [
        "--set"
        "MOZ_SYSTEM_DIR"
        "${placeholder "out"}/lib/mozilla"

      ]
      ++ lib.optionals (!hasMozSystemDirPatch && allNativeMessagingHosts != [ ]) [
        "--run"
        ''mkdir -p ''${MOZ_HOME:-~/.mozilla}/native-messaging-hosts''

      ]
      ++ lib.optionals (!hasMozSystemDirPatch) (
        lib.concatMap (ext: [
          "--run"
          ''ln -sfLt ''${MOZ_HOME:-~/.mozilla}/native-messaging-hosts ${ext}/lib/mozilla/native-messaging-hosts/*''
        ]) allNativeMessagingHosts
      );

      buildCommand =
        let
          appPath = "Applications/${browser.applicationName}.app";
          executablePrefix = if isDarwin then "${appPath}/Contents/MacOS" else "bin";
          executablePath = "${executablePrefix}/${applicationName}";
          finalBinaryPath = "${executablePath}" + lib.optionalString (!isDarwin) "${nameSuffix}";
          sourceBinary = "${browser}/${executablePath}";
          libDir = if isDarwin then "${appPath}/Contents/Resources" else "lib/${libName}";
          prefsDir = if isDarwin then "${libDir}/browser/defaults/preferences" else "${libDir}/defaults/pref";
        in
        ''
          if [ ! -x "${sourceBinary}" ]
          then
              echo "cannot find executable file \`${sourceBinary}'"
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

          find . -type l -print0 | while read -d $'\0' l; do
            target="$(readlink "$l")"
            target=''${target/#"${browser}"/"$out"}
            ln -sfT "$target" "$out/$l"
          done

          cd "$out"

        ''
        + lib.optionalString isDarwin ''
          cd "${appPath}"

          # The omni.ja files have to be copied and not symlinked, otherwise tabs crash.
          # Maybe related to how omni.ja file is mmapped into memory. See:
          # https://github.com/mozilla/gecko-dev/blob/b1662b447f306e6554647914090d4b73ac8e1664/modules/libjar/nsZipArchive.cpp#L204
          #
          # The *.dylib files are copied, otherwise some basic functionality, e.g. Crypto API, is broken.
          for file in $(find . -name "omni.ja" -o -name "*.dylib"); do
            rm "$file"
            cp "${browser}/${appPath}/$file" "$file"
          done

          # Copy any embedded .app directories; plugin-container fails to start otherwise.
          for dir in $(find . -type d -name '*.app'); do
            rm -r "$dir"
            cp -r "${browser}/${appPath}/$dir" "$dir"
          done

          cd ..

        ''
        + ''

          # create the wrapper

          executablePrefix="$out/${executablePrefix}"
          executablePath="$out/${executablePath}"
          oldWrapperArgs=()

          if [[ -L $executablePath ]]; then
            # Symbolic link: wrap the link's target.
            oldExe="$(readlink -v --canonicalize-existing "$executablePath")"
            rm "$executablePath"
          elif wrapperCmd=$(${buildPackages.makeBinaryWrapper.extractCmd} "$executablePath"); [[ $wrapperCmd ]]; then
            # If the executable is a binary wrapper, we need to update its target to
            # point to $out, but we can't just edit the binary in-place because of length
            # issues. So we extract the command used to create the wrapper and add the
            # arguments to our wrapper.
            parseMakeCWrapperCall() {
              shift # makeCWrapper
              oldExe=$1; shift
              oldWrapperArgs=("$@")
            }
            eval "parseMakeCWrapperCall ''${wrapperCmd//"${browser}"/"$out"}"
            rm "$executablePath"
          else
            if read -rn2 shebang < "$executablePath" && [[ $shebang == '#!' ]]; then
              # Shell wrapper: patch in place to point to $out.
              sed -i "s@${browser}@$out@g" "$executablePath"
            fi
            # Suffix the executable with -old, because -wrapped might already be used by the old wrapper.
            oldExe="$executablePrefix/.${applicationName}"-old
            mv "$executablePath" "$oldExe"
          fi
        ''
        + lib.optionalString (!isDarwin) ''
          appendToVar makeWrapperArgs --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
        ''
        + ''
          concatTo makeWrapperArgs oldWrapperArgs

          makeWrapper "$oldExe" "$out/${finalBinaryPath}" "''${makeWrapperArgs[@]}"

          #############################
          #                           #
          #   END EXTRA PREF CHANGES  #
          #                           #
          #############################
        ''
        + lib.optionalString (!isDarwin) ''
          if [ -e "${browser}/share/icons" ]; then
              mkdir -p "$out/share"
              ln -s "${browser}/share/icons" "$out/share/icons"
          else
              for res in 16 32 48 64 128; do
              mkdir -p "$out/share/icons/hicolor/''${res}x''${res}/apps"
              icon=$( find "${browser}/lib/" -name "default''${res}.png" )
                if [ -e "$icon" ]; then ln -s "$icon" \
                  "$out/share/icons/hicolor/''${res}x''${res}/apps/${icon}.png"
                fi
              done
          fi

          install -m 644 -D -t $out/share/applications $desktopItem/share/applications/*

        ''
        + lib.optionalString hasMozSystemDirPatch ''
          mkdir -p $out/lib/mozilla/native-messaging-hosts
          for ext in ${toString allNativeMessagingHosts}; do
              ln -sLt $out/lib/mozilla/native-messaging-hosts $ext/lib/mozilla/native-messaging-hosts/*
          done
        ''
        + ''

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
          libDir="$out/${libDir}"

          # creating policies.json
          mkdir -p "$libDir/distribution"

          POL_PATH="$libDir/distribution/policies.json"
          rm -f "$POL_PATH"
          cat ${policiesJson} >> "$POL_PATH"

          extraPoliciesFiles=(${toString extraPoliciesFiles})
          for extraPoliciesFile in "''${extraPoliciesFiles[@]}"; do
            jq -s '.[0] * .[1]' $extraPoliciesFile "$POL_PATH" > .tmp.json
            mv .tmp.json "$POL_PATH"
          done

          # preparing for autoconfig
          prefsDir="$out/${prefsDir}"
          mkdir -p "$prefsDir"

          echo 'pref("general.config.filename", "mozilla.cfg");' > "$prefsDir/autoconfig.js"
          echo 'pref("general.config.obscure_value", 0);' >> "$prefsDir/autoconfig.js"

          cat > "$libDir/mozilla.cfg" << EOF
          ${mozillaCfg}
          EOF

          extraPrefsFiles=(${toString extraPrefsFiles})
          for extraPrefsFile in "''${extraPrefsFiles[@]}"; do
            cat "$extraPrefsFile" >> "$libDir/mozilla.cfg"
          done

          cat >> "$libDir/mozilla.cfg" << EOF
          ${extraPrefs}
          EOF

          mkdir -p "$libDir/distribution/extensions"

          #############################
          #                           #
          #   END EXTRA PREF CHANGES  #
          #                           #
          #############################
        '';

      preferLocalBuild = true;

      libs = lib.makeLibraryPath libs + ":" + lib.makeSearchPathOutput "lib" "lib64" libs;
      gtk_modules = map (x: x + x.gtkModule) gtk_modules;

      passthru = {
        unwrapped = browser;
      };

      disallowedRequisites = [ stdenv.cc ];
      meta = browser.meta // {
        inherit (browser.meta) description;
        mainProgram = launcherName;
        hydraPlatforms = [ ];
        priority = (browser.meta.priority or lib.meta.defaultPriority) - 1; # prefer wrapper over the package
      };
    });
in
lib.makeOverridable wrapper
