{ stdenv
, lib
, cacert
, curl
, runCommandLocal
, unzip
, appimage-run
, addOpenGLRunpath
, dbus
, libGLU
, xorg
, buildFHSEnv
, buildFHSEnvChroot
, bash
, writeText
, ocl-icd
, xkeyboard_config
, glib
, libarchive
, libxcrypt
, python3
, aprutil
, makeDesktopItem
, copyDesktopItems
}:

let
  davinci = (
    stdenv.mkDerivation rec {
      pname = "davinci-resolve";
      version = "18.5.1";

      nativeBuildInputs = [
        (appimage-run.override { buildFHSEnv = buildFHSEnvChroot; } )
        addOpenGLRunpath
        copyDesktopItems
        unzip
      ];

      # Pretty sure, there are missing dependencies ...
      buildInputs = [
        libGLU
        xorg.libXxf86vm
      ];

      src = runCommandLocal "${pname}-src.zip"
        rec {
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = "sha256-AZ869hA/WeCf3sxhdDOzD/q30P1NaD18TheBtS1ammQ=";

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;

          nativeBuildInputs = [ curl ];

          # ENV VARS
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

          # Get linux.downloadId from HTTP response on https://www.blackmagicdesign.com/products/davinciresolve
          DOWNLOADID = "defc1c6789b7475b9ee4a42daf9ba61d";
          REFERID = "263d62f31cbb49e0868005059abcb0c9";
          SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";

          USERAGENT = builtins.concatStringsSep " " [
            "User-Agent: Mozilla/5.0 (X11; Linux ${stdenv.targetPlatform.linuxArch})"
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
            "street" = "Hogeweide 346";
            "state" = "Province of Utrecht";
            "city" = "Utrecht";
            "product" = "DaVinci Resolve";
          };

        } ''
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
          "$SITEURL")

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

      installPhase = ''
        runHook preInstall

        export HOME=$PWD/home
        mkdir -p $HOME

        mkdir -p $out
        appimage-run ./DaVinci_Resolve_${version}_Linux.run -i -y -n -C $out

        mkdir -p $out/{configs,DolbyVision,easyDCP,Fairlight,GPUCache,logs,Media,"Resolve Disk Database",.crashreport,.license,.LUT}
        runHook postInstall
      '';

      dontStrip = true;

      postFixup = ''
        for program in $out/bin/*; do
          isELF "$program" || continue
          addOpenGLRunpath "$program"
        done

        for program in $out/libs/*; do
          isELF "$program" || continue
          if [[ "$program" != *"libcudnn_cnn_infer"* ]];then
            echo $program
            addOpenGLRunpath "$program"
          fi
        done
        ln -s $out/libs/libcrypto.so.1.1 $out/libs/libcrypt.so.1
      '';

      desktopItems = [
        (makeDesktopItem {
          name = "davinci-resolve";
          desktopName = "Davinci Resolve";
          genericName = "Video Editor";
          exec = "resolve";
          # icon = "DV_Resolve";
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
  name = "davinci-resolve";
  targetPkgs = pkgs: with pkgs; [
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

  runScript = "${bash}/bin/bash ${
    writeText "davinci-wrapper"
    ''
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
    export QT_PLUGIN_PATH="${davinci}/libs/plugins:$QT_PLUGIN_PATH"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${davinci}/libs
    ${davinci}/bin/resolve
    ''
  }";

  meta = with lib; {
    description = "Professional video editing, color, effects and audio post-processing";
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
