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
}:

let
  davinci = (
    stdenv.mkDerivation rec {
      pname = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
      version = "19.1";

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
                "sha256-uEUZt0TQ4XrAag6NoCPUtYSnkwpwh3BNlol1z/EmP9E="
              else
                "sha256-3VVyfXT/mZFuf2GGkNS47ErSdAGpdUUwwwKY19zBBZo=";

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

          mkdir -p $out/{configs,DolbyVision,easyDCP,Fairlight,GPUCache,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT}
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

      desktopItems = [
        (makeDesktopItem {
          name = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          desktopName = "Davinci Resolve${lib.optionalString studioVariant " Studio"}";
          genericName = "Video Editor";
          exec = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          icon = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
          comment = "Professional video editing, color, effects and audio post-processing";
          categories = [
            "AudioVideo"
            "AudioVideoEditing"
            "Video"
            "Graphics"
          ];
        })
      ];
    }
  );
in
buildFHSEnv {
  inherit (davinci) pname version;

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
      libGL
      libGLU
      libarchive
      libcap
      librsvg
      libtool
      libuuid
      libxcrypt # provides libcrypt.so.1
      libxkbcommon
      nspr
      ocl-icd
      opencl-headers
      python3
      python3.pkgs.numpy
      udev
      xdg-utils # xdg-open needed to open URLs
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
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
    export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci}/libs
    ${davinci}/bin/resolve
  ''}";

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
    ln -s ${davinci}/share/applications/*.desktop $out/share/applications/
    ln -s ${davinci}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve${lib.optionalString studioVariant "-studio"}.png
  '';

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
        drv=pkgs/applications/video/davinci-resolve/default.nix
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
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
    license = licenses.unfree;
    maintainers = with maintainers; [
      amarshall
      jshcmpbll
      orivej
    ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "davinci-resolve${lib.optionalString studioVariant "-studio"}";
  };
}
