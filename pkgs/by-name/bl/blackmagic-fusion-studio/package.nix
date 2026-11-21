# Note, this package is based on the 'davinci-resolve-studio' package.
{
  stdenv,
  lib,
  appimageTools,
  buildFHSEnv,
  bash,
  writeText,
  xkeyboard_config,
  makeDesktopItem,
  copyDesktopItems,
  prelink,
  curl,
  jq,
  cacert,
  unzip,
  runCommandLocal,
  writeShellScript,
  writeShellApplication,
  common-updater-scripts,
}:

let
  fusion = (
    stdenv.mkDerivation rec {
      pname = "blackmagic-fusion-studio";
      version = "21.1.1";

      nativeBuildInputs = [
        appimageTools.appimage-exec
        copyDesktopItems
        unzip
      ];

      src =
        runCommandLocal "${pname}-src.zip"
          rec {
            outputHashMode = "recursive";
            outputHashAlgo = "sha256";
            outputHash = "sha256-M14oFyeBN0YWXVC1SST49GIcDniEzXzFk00p+ln9JJE=";

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
            PRODUCT = "Fusion Studio";
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
          appimageName = "Blackmagic_Fusion_Studio_Linux_${version}_installer.run";
        in
        ''
          runHook preInstall

          export HOME=$PWD/home
          mkdir -p $HOME

          mkdir -p $out
          test -e ${lib.escapeShellArg appimageName}
          appimage-exec.sh -x $out ${lib.escapeShellArg appimageName}


          # Install udev rules for Fusion license dongle
          mkdir -p $out/lib/udev/rules.d
          # Generate catch-all rules for Blackmagic Design vendor ID (096e)
          # USB device access (color panels, general hardware)
          echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="096e", MODE="0666"' \
            > $out/lib/udev/rules.d/99-BlackmagicDongle.rules
          echo 'SUBSYSTEMS=="usb", ATTRS{idVendor}=="1edb", MODE="0666"' \
          > $out/lib/udev/rules.d/99-BlackmagicHardware.rules
          test -f $out/lib/udev/rules.d/99-BlackmagicDongle.rules
          test -f $out/lib/udev/rules.d/99-BlackmagicHardware.rules
          runHook postInstall
        '';

      dontStrip = true;

      desktopItems = [
        (makeDesktopItem {
          name = "blackmagic-fusion-studio";
          desktopName = "Blackmagic Fusion Studio";
          genericName = "Video Editor";
          exec = "blackmagic-fusion-studio";
          icon = "blackmagic-fusion-studio";
          comment = "Professional 2D compositing suite";
          categories = [
            "AudioVideo"
            "AudioVideoEditing"
            "Video"
            "Graphics"
          ];
          startupWMClass = "Fusion";
        })
      ];
    }
  );
in
buildFHSEnv {
  inherit (fusion) pname version;

  targetPkgs =
    pkgs: with pkgs; [
      alsa-lib
      bzip2
      fusion
      dbus
      fontconfig
      freetype
      glib
      libGL
      libGLU
      libuuid
      libice
      libsm
      libxcb
      libxcb-util
      libxcb-wm
      libxcb-render-util
      libxcb-keysyms
      libxcb-image
      libxkbcommon
      libxt
      libxtst
      libxrender
      libxrandr
      libxi
      libxinerama
      libxfixes
      libxext
      libxdamage
      libxcursor
      libxcomposite
      libx11
      libsm
      libice
      ocl-icd
      python3
      stdenv.cc.cc.lib
      xkeyboard-config
      zlib
      curl # Needed for Reactor (community add-on manager)
    ];

  runScript = "${bash}/bin/bash ${writeText "fusion-wrapper" ''
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
    export QT_PLUGIN_PATH="${fusion}/libs/plugins:$QT_PLUGIN_PATH"
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${fusion}:${fusion}/Frameworks/lib:${fusion}/Frameworks/platforms"
    exec ${fusion}/Fusion "$@"
  ''}";

  extraInstallCommands =
    let
      majorVersion = builtins.elemAt (lib.strings.splitString "." fusion.version) 0;
    in
    ''
      # Desktop files
      mkdir -p $out/share/applications
      cat ${fusion}/Fusion.desktop \
      | sed -e "s|/opt/BlackmagicDesign/Fusion${majorVersion}/Fusion|blackmagic-fusion-studio|" \
      | sed -e "s|Path=/opt/BlackmagicDesign/Fusion${majorVersion}|Path=|" \
      > $out/share/applications/blackmagic-fusion-studio.desktop

      # Icons
      mkdir -p $out/share/icons/hicolor/{128x128,256x256}/apps
      ln -s ${fusion}/blackmagic-Fusion${majorVersion}.png $out/share/icons/hicolor/128x128/apps/blackmagic-Fusion${majorVersion}.png

      # MIME type definition for .comp
      mkdir -p $out/share/mime/packages
      ln -s ${fusion}/fusion.xml $out/share/mime/packages/fusion-studio.xml

      # Expose udev rules so NixOS can aggregate them from environment.systemPackages
      mkdir -p $out/lib/udev/rules.d
      ln -s ${fusion}/lib/udev/rules.d/99-BlackmagicDongle.rules $out/lib/udev/rules.d/
      ln -s ${fusion}/lib/udev/rules.d/99-BlackmagicHardware.rules $out/lib/udev/rules.d/
    '';

  passthru = {
    inherit fusion;
  };

  updateScript = lib.getExe (writeShellApplication {
    name = "update-blackmagic-fusion-studio";
    runtimeInputs = [
      curl
      jq
      common-updater-scripts
    ];
    text = ''
      set -o errexit
      downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"
      latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("Fusion Studio")) | .downloadTitle]' | grep -oP 'Fusion Studio \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
      update-source-version blackmagic-fusion-studio "$latestLinuxVersion" --source-key=fusion.src
    '';
  });

  meta = {
    description = "Post-production image compositing software";
    homepage = "https://www.blackmagicdesign.com/products/fusion";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.bryab ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "blackmagic-fusion-studio";
  };
}
