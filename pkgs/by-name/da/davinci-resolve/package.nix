{
  stdenv,
  lib,
  cacert,
  curl,
  runCommandLocal,
  unzip,
  appimage-run,
  addDriverRunpath,
  dbus,
  libGLU,
  xorg,
  buildFHSEnv,
  buildFHSEnvChroot,
  bash,
  symlinkJoin,
  writeShellScriptBin,
  writeText,
  ocl-icd,
  xkeyboard_config,
  glib,
  libarchive,
  libxcrypt,
  python3,
  aprutil,
  makeDesktopItem,
  copyDesktopItems,
  jq,

  studioVariant ? false,

  common-updater-scripts,
  writeShellApplication,

  # overriding pythonPackage allows customizing python in the FHS environment
  pythonPackage ? (python3.withPackages (python-pkgs: with python-pkgs; [
    numpy
  ])),

}:

let
  davinci = (
    stdenv.mkDerivation rec {
      pname = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
      version = "20.0";

      nativeBuildInputs = [
        (appimage-run.override { buildFHSEnv = buildFHSEnvChroot; })
        addDriverRunpath
        copyDesktopItems
        unzip
      ];

      # Pretty sure, there are missing dependencies ...
      buildInputs = [
        libGLU
        xorg.libXxf86vm
      ];

      src =
        runCommandLocal "${pname}-src.zip"
          rec {
            outputHashMode = "recursive";
            outputHashAlgo = "sha256";
            outputHash =
              if studioVariant then
                "sha256-q0jfP/DtroK7Dzj/BiB1JmYPihCma/OgcGmQOE/uwGY="
              else
                "sha256-JM/V449KUEXuQmRpyQC2z9DRmID7hJ3Mnt5N6p/HOXA=";

            impureEnvVars = lib.fetchers.proxyImpureEnvVars;

            nativeBuildInputs = [
              curl
              jq
            ];

            # ENV VARS
            SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

            # Get linux.downloadId from HTTP response on https://www.blackmagicdesign.com/products/davinciresolve
            REFERID = "263d62f31cbb49e0868005059abcb0c9";
            DOWNLOADSURL = "https://www.blackmagicdesign.com/api/support/us/downloads.json";
            SITEURL = "https://www.blackmagicdesign.com/api/register/us/download";
            PRODUCT = "DaVinci Resolve${lib.optionalString studioVariant " Studio"}";
            VERSION = version;

            USERAGENT = builtins.concatStringsSep " " [
              "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.hostPlatform.linuxArch})"
              "AppleWebKit/537.36 (KHTML, like Gecko)"
              "Chrome/77.0.3865.75"
              "Safari/537.36"
            ];

            REQJSON = builtins.toJSON {
              "firstname" = "NixOS";
              "lastname" = "Linux";
              "email" = "someone@nixos.org";
              "phone" = "+31 71 452 5670";
              "country" = "nl";
              "street" = "-";
              "state" = "Province of Utrecht";
              "city" = "Utrecht";
              "product" = PRODUCT;
            };

          }
          ''
            DOWNLOADID=$(
              curl --silent --compressed "$DOWNLOADSURL" \
                | jq --raw-output '.downloads[] | .urls.Linux?[]? | select(.downloadTitle | test("^'"$PRODUCT $VERSION"'( Update)?$")) | .downloadId'
            )
            echo "downloadid is $DOWNLOADID"
            test -n "$DOWNLOADID"
            RESOLVEURL=$(curl \
              --silent \
              --header 'Host: www.blackmagicdesign.com' \
              --header 'Accept: application/json, text/plain, */*' \
              --header 'Origin: https://www.blackmagicdesign.com' \
              --header "$USERAGENT" \
              --header 'Content-Type: application/json;charset=UTF-8' \
              --header "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
              --header 'Accept-Encoding: gzip, deflate, br' \
              --header 'Accept-Language: en-US,en;q=0.9' \
              --header 'Authority: www.blackmagicdesign.com' \
              --header 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
              --data-ascii "$REQJSON" \
              --compressed \
              "$SITEURL/$DOWNLOADID")
            echo "resolveurl is $RESOLVEURL"

            curl \
              --retry 3 --retry-delay 3 \
              --header "Upgrade-Insecure-Requests: 1" \
              --header "$USERAGENT" \
              --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
              --header "Accept-Language: en-US,en;q=0.9" \
              --compressed \
              "$RESOLVEURL" \
              > $out
          '';

      # The unpack phase won't generate a directory
      sourceRoot = ".";

      installPhase =
        let
          appimageName = "DaVinci_Resolve_${lib.optionalString studioVariant "Studio_"}${version}_Linux.run";
        in
        ''
          runHook preInstall

          export HOME=$PWD/home
          mkdir -p $HOME

          mkdir -p $out
          test -e ${lib.escapeShellArg appimageName}
          appimage-run ${lib.escapeShellArg appimageName} -i -y -n -C $out

          mkdir -p $out/{configs,DolbyVision,easyDCP,Fairlight,GPUCache,lib,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT}

          # For hardware panel support, Resolve requires the panel libraries to be unpacked to the
          # library search path within the FHS environment.
          tar xf $out/share/panels/dvpanel-framework-linux-x86_64.tgz -C $out/lib

          runHook postInstall
        '';

      dontStrip = true;

      postFixup = ''
        for program in $out/bin/*; do
          isELF "$program" || continue
          addDriverRunpath "$program"
        done

        for program in $out/libs/*; do
          isELF "$program" || continue
          if [[ "$program" != *"libcudnn_cnn_infer"* ]];then
            echo $program
            addDriverRunpath "$program"
          fi
        done
        ln -s $out/libs/libcrypto.so.1.1 $out/libs/libcrypt.so.1
      '';
    }
  );

fhs = buildFHSEnv {
  pname = "${davinci.pname}-fhs";
  inherit (davinci) version;

  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      aprutil
      bzip2
      davinci
      dbus
      expat
      fontconfig
      freetype
      glib
      krb5  # for DaVinci Control Panels Setup
      libGL
      libGLU
      libarchive
      libcap
      libdrm
      libpng12
      librsvg
      libtool
      libusb1
      libuuid
      libxcrypt  # provides libcrypt.so.1
      libxkbcommon
      nspr
      nss
      ocl-icd
      opencl-headers
      pythonPackage
      udev
      xcb-util-cursor
      xdg-utils  # xdg-open needed to open URLs
      xorg.libICE
      xorg.libSM
      xorg.libX11
      xorg.libXcomposite
      xorg.libXcursor
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXinerama
      xorg.libxkbfile
      xorg.libXrandr
      xorg.libXrender
      xorg.libXt
      xorg.libXtst
      xorg.libXxf86vm
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.xcbutilwm
      xorg.xkeyboardconfig
      zlib
    ];

  extraPreBwrapCmds = lib.optionalString studioVariant ''
    mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
  '';

  extraBwrapArgs = lib.optionals studioVariant [
    "--bind \"$HOME\"/.local/share/DaVinciResolve/license ${davinci}/.license"
  ];

  runScript = "${bash}/bin/bash ${writeText "davinci-wrapper" ''
    exec "$@"
  ''}";

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    ln -s ${davinci}/share/applications/*.desktop $out/share/applications/
  '';
};

resolveUdev = runCommandLocal "${davinci.pname}-udev" {} ''
  mkdir -p $out/etc/udev/rules.d
  # follows the resolve install script, see scripts/post_install.sh
  DVP_RULES=$out/etc/udev/rules.d/75-davincipanel.rules
  DVK_RULES=$out/etc/udev/rules.d/75-davincikb.rules
  SDX_RULES=$out/etc/udev/rules.d/75-sdx.rules
  cat ${davinci}/share/etc/udev/rules.d/99-BlackmagicDevices.rules > $DVP_RULES
  echo 'KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0777", GROUP="resolve"' >> $DVP_RULES
  cat ${davinci}/share/etc/udev/rules.d/99-ResolveKeyboardHID.rules > $DVK_RULES
  echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"' > $SDX_RULES
'';

resolveXdg = runCommandLocal "${davinci.pname}-xdg" {} ''
  # icons for applications
  mkdir -p $out/share/icons/hicolor/{48x48,128x128,256x256}/apps
  ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/${davinci.pname}.png
  ln -s ${davinci}/graphics/DV_Panels.png $out/share/icons/hicolor/128x128/apps/${davinci.pname}-panels.png
  ln -s ${davinci}/graphics/Remote_Monitoring.png $out/share/icons/hicolor/128x128/apps/${davinci.pname}-monitor.png
  ln -s ${davinci}/graphics/blackmagicraw-speedtest_256x256_apps.png $out/share/icons/hicolor/256x256/apps/${davinci.pname}-raw-speed-test.png
  ln -s ${davinci}/graphics/blackmagicraw-speedtest_48x48_apps.png $out/share/icons/hicolor/48x48/apps/${davinci.pname}-raw-speed-test.png
  ln -s ${davinci}/graphics/blackmagicraw-player_256x256_apps.png $out/share/icons/hicolor/256x256/apps/${davinci.pname}-raw-player.png
  ln -s ${davinci}/graphics/blackmagicraw-player_48x48_apps.png $out/share/icons/hicolor/48x48/apps/${davinci.pname}-raw-player.png

  # icons for mime types
  mkdir -p $out/share/icons/hicolor/{48x48,128x128,256x256}/mimetypes

  ln -s ${davinci}/graphics/application-x-braw-clip_48x48_mimetypes.png $out/share/icons/hicolor/48x48/mimetypes/application-x-braw-clip.png
  ln -s ${davinci}/graphics/application-x-braw-sidecar_48x48_mimetypes.png $out/share/icons/hicolor/48x48/mimetypes/application-x-braw-sidecar.png
  ln -s ${davinci}/graphics/application-x-braw-clip_256x256_mimetypes.png $out/share/icons/hicolor/256x256/mimetypes/application-x-braw-clip.png
  ln -s ${davinci}/graphics/application-x-braw-sidecar_256x256_mimetypes.png $out/share/icons/hicolor/256x256/mimetypes/application-x-braw-sidecar.png
  ln -s ${davinci}/graphics/DV_ResolveBin.png $out/share/icons/hicolor/128x128/mimetypes/application-x-resolvebin.png
  ln -s ${davinci}/graphics/DV_ResolveProj.png $out/share/icons/hicolor/128x128/mimetypes/application-x-resolveproj.png
  ln -s ${davinci}/graphics/DV_ResolveTimeline.png $out/share/icons/hicolor/128x128/mimetypes/application-x-resolvetimeline.png
  ln -s ${davinci}/graphics/DV_TemplateBundle.png $out/share/icons/hicolor/128x128/mimetypes/application-x-resolvetemplatebundle.png

  # mime types
  mkdir -p $out/share/mime/packages
  # without these patches, GNOME displays blank icons
  cat ${davinci}/share/blackmagicraw.xml \
    | sed '/<mime-type type="application\/x-braw-clip">/a <generic-icon name="application-x-braw-clip"/>' \
    | sed '/<mime-type type="application\/x-braw-sidecar">/a <generic-icon name="application-x-braw-sidecar"/>' \
    > $out/share/mime/packages/${davinci.pname}-raw.xml
  cat ${davinci}/share/resolve.xml \
    | sed '/<mime-type type="application\/x-resolveproj">/a <generic-icon name="application-x-resolveproj"/>' \
    | sed '/<mime-type type="application\/x-resolvedbkey">/a <generic-icon name="application-x-resolvedbkey"/>' \
    | sed '/<mime-type type="application\/x-resolvebin">/a <generic-icon name="application-x-resolvebin"/>' \
    | sed '/<mime-type type="application\/x-resolvetimeline">/a <generic-icon name="application-x-resolvetimeline"/>' \
    | sed '/<mime-type type="application\/x-resolvetemplatebundle">/a <generic-icon name="application-x-resolvetemplatebundle"/>' \
    > $out/share/mime/packages/${davinci.pname}.xml
'';

wrapper = ''${fhs}/bin/${davinci.pname}-fhs'';

# creates a derivation that wraps the "path" command with arguments in "args" list to run inside the FHS
# the directories in "libs" and "plugins" are put into LD_LIBRARY_PATH and QT_PLUGIN_PATH
mkWrapper = path: libs: plugins: args: writeShellScriptBin path ''
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
    export QT_PLUGIN_PATH="${plugins}:$QT_PLUGIN_PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${libs}"

    # this allows Python to find the modules, see Developer/Scripting/README.txt
    export RESOLVE_SCRIPT_API="${davinci}/Developer/Scripting"
    export RESOLVE_SCRIPT_LIB="${davinci}/libs/Fusion/fusionscript.so"
    export PYTHONPATH="$PYTHONPATH:${davinci}/Developer/Scripting/Modules"

    exec ${lib.strings.concatMapStringsSep " " lib.escapeShellArg ([wrapper] ++ args)} "$@"
'';

# wrap main executable
resolveWrapper = mkWrapper "${davinci.pname}" "${davinci}/libs" "${davinci}/libs/plugins" ["${davinci}/bin/resolve"];

# This provides the "davinci-resolve-shell"/"davinci-resolve-studio-shell" command to open a shell in the correct FHS
# in order to simplify running Resolve and related tools from the command line.
resolveShellWrapper = mkWrapper "${davinci.pname}-shell" "${davinci}/libs" "${davinci}/libs/plugins" ["/usr/bin/env" "bash"];

panelSetupWrapper = mkWrapper "${davinci.pname}-panels" "${davinci}/DaVinci Control Panels Setup" "${davinci}/DaVinci Control Panels Setup/plugins" ["${davinci}/DaVinci Control Panels Setup/DaVinci Control Panels Setup"];

rawSpeedTestWrapper = mkWrapper "${davinci.pname}-raw-speed-test" "${davinci}/BlackmagicRAWSpeedTest/lib" "${davinci}/BlackmagicRAWSpeedTest/plugins" ["${davinci}/BlackmagicRAWSpeedTest/BlackmagicRAWSpeedTest"];

rawPlayerWrapper = mkWrapper "${davinci.pname}-raw-player" "${davinci}/BlackmagicRAWPlayer/lib" "${davinci}/BlackmagicRAWPlayer/plugins" ["${davinci}/BlackmagicRAWPlayer/BlackmagicRAWPlayer"];

remoteMonitorWrapper = mkWrapper "${davinci.pname}-monitor" "${davinci}/libs" "${davinci}/libs/plugins" ["${davinci}/bin/DaVinci Remote Monitor"];

pythonWrapper = mkWrapper "${davinci.pname}-python" "${davinci}/libs" "${davinci}/libs/plugins" [ "${pythonPackage}/bin/python" ];

product = "DaVinci Resolve${lib.optionalString studioVariant " Studio"}";

in
symlinkJoin {

  inherit (davinci) pname version;

  paths = [

    resolveWrapper
    resolveShellWrapper
    panelSetupWrapper
    rawSpeedTestWrapper
    rawPlayerWrapper
    remoteMonitorWrapper
    pythonWrapper

    resolveUdev
    resolveXdg

    (makeDesktopItem {
      name = "${davinci.pname}";
      desktopName = "${product}";
      genericName = "Video Editor";
      exec = "${resolveWrapper}/bin/${davinci.pname}";
      icon = "${davinci.pname}";
      comment = "Professional video editing, color, effects and audio post-processing";
      mimeTypes = ["application/x-resolveproj"];
      startupNotify = true;
      terminal = false;
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
    })

    (makeDesktopItem {
      name = "${davinci.pname}-panels";
      desktopName = "${product} Control Panels Setup";
      exec = "${panelSetupWrapper}/bin/${davinci.pname}-panels";
      icon = "${davinci.pname}-panels";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
    })

    (makeDesktopItem {
      name = "${davinci.pname}-raw-speed-test";
      desktopName = "${product} Blackmagic RAW Speed Test";
      exec = "${rawSpeedTestWrapper}/bin/${davinci.pname}-raw-speed-test";
      icon = "${davinci.pname}-raw-speed-test";
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
    })

    (makeDesktopItem {
      name = "${davinci.pname}-raw-player";
      desktopName = "${product} Blackmagic RAW Player";
      exec = "${rawPlayerWrapper}/bin/${davinci.pname}-raw-player %f";
      icon = "${davinci.pname}-raw-player";
      mimeTypes = ["application/x-braw-clip" "application/x-braw-sidecar"];
      terminal = false;
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
    })

  ] ++ lib.lists.optionals studioVariant [

    # remote monitor is not available in the non-studio version

    remoteMonitorWrapper

    (makeDesktopItem {
      name = "${davinci.pname}-monitor";
      desktopName = "${product} Remote Monitor";
      exec = "${remoteMonitorWrapper}/bin/${davinci.pname}-monitor";
      icon = "${davinci.pname}-monitor";
      startupNotify = true;
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
        "Video"
        "Graphics"
      ];
    })

  ];

  passthru = {
    inherit davinci;
    updateScript = lib.getExe (writeShellApplication {
      name = "update-davinci-resolve";
      runtimeInputs = [
        curl
        jq
        common-updater-scripts
      ];
      text = ''
        set -o errexit
        drv=pkgs/by-name/da/davinci-resolve/package.nix
        currentVersion=${lib.escapeShellArg davinci.version}
        downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"

        latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
        update-source-version davinci-resolve "$latestLinuxVersion" --source-key=davinci.src

        # Since the standard and studio both use the same version we need to reset it before updating studio
        sed -i -e "s/""$latestLinuxVersion""/""$currentVersion""/" "$drv"

        latestStudioLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve Studio \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
        update-source-version davinci-resolve-studio "$latestStudioLinuxVersion" --source-key=davinci.src
      '';
    });
  };

  meta = with lib; {
    description = "Professional video editing, color, effects and audio post-processing";
    longDescription = ''
      ${product} includes a non-linear video editor, color grading tool, video effects
      editor and track-based audio post-processing tool. The main executable `${davinci.pname}`
      is wrapped in an FHS environment. For scripting and other purposes, the package provides the
      `${davinci.pname}-shell` command, which opens a shell within the FHS environment.

      Using hardware hardware panels with Resolve requires a physical USB connection and setting `udev` rules via
      ```
      services.udev.packages =
        with pkgs; [
          ${davinci.pname}
        ];
      ```

      Scripting using Python is supported. To add Python packages, override `pythonPackage`.
      Example, corresponding to the default:
      ```
      environment.systemPackages = with pkgs; [
        (${davinci.pname}.override {
           pythonPackage = python3.withPackages (python-pkgs: with python-pkgs; [
             numpy
             # add extra Python packages here
          ]);
        })
      ];
      ```
      Use `${davinci.pname}-python` to run Python inside the FHS environment.
    '' + (lib.optionalString studioVariant ''

      DaVinci Resolve Studio additionally support remote scripting. Example:
      ```
      ${davinci.pname} -nogui & sleep 30  # wait until Resolve has started up
      SCRIPTING_PATH=''$(${davinci.pname}-shell -c "printenv RESOLVE_SCRIPT_API")
      ${davinci.pname}-python ''$SCRIPTING_PATH/Examples/4_display_project_and_folder_tree.py
      ```
    '');
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
    license = licenses.unfree;
    maintainers = with maintainers; [
      amarshall
      jshcmpbll
      orivej
      XBagon
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "${davinci.pname}";
  };
}
