{ stdenv
, lib
, cacert
, curl
, runCommandLocal
, unzip
, appimage-run
, addOpenGLRunpath
<<<<<<< HEAD
, dbus
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, python3
, aprutil
, makeDesktopItem
, copyDesktopItems
=======
, python2
, aprutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  davinci = (
    stdenv.mkDerivation rec {
      pname = "davinci-resolve";
<<<<<<< HEAD
      version = "18.1.4";

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
=======
      version = "17.4.3";

      nativeBuildInputs = [
        unzip
        (appimage-run.override { buildFHSEnv = buildFHSEnvChroot; } )
        addOpenGLRunpath
      ];

      # Pretty sure, there are missing dependencies ...
      buildInputs = [ libGLU xorg.libXxf86vm ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      src = runCommandLocal "${pname}-src.zip"
        rec {
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
<<<<<<< HEAD
          outputHash = "sha256-yUKT1x5LrzdGLDZjZDeTvNgRAzeR+rn18AGY5Mn+5As=";
=======
          outputHash = "0hq374n26mbcds8f1z644cvnh4h2rjdrbxxxbj4p34mx9b04ab28";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;

          nativeBuildInputs = [ curl ];

          # ENV VARS
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

<<<<<<< HEAD
          # Get linux.downloadId from HTTP response on https://www.blackmagicdesign.com/products/davinciresolve
          DOWNLOADID = "6449dc76e0b845bcb7399964b00a3ec4";
=======
          DOWNLOADID = "5efad1a052e8471989f662338d5247f1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
            "street" = "Hogeweide 346";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            "state" = "Province of Utrecht";
            "city" = "Utrecht";
            "product" = "DaVinci Resolve";
          };

        } ''
        RESOLVEURL=$(curl \
<<<<<<< HEAD
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
=======
          -s \
          -H 'Host: www.blackmagicdesign.com' \
          -H 'Accept: application/json, text/plain, */*' \
          -H 'Origin: https://www.blackmagicdesign.com' \
          -H "$USERAGENT" \
          -H 'Content-Type: application/json;charset=UTF-8' \
          -H "Referer: https://www.blackmagicdesign.com/support/download/$REFERID/Linux" \
          -H 'Accept-Encoding: gzip, deflate, br' \
          -H 'Accept-Language: en-US,en;q=0.9' \
          -H 'Authority: www.blackmagicdesign.com' \
          -H 'Cookie: _ga=GA1.2.1849503966.1518103294; _gid=GA1.2.953840595.1518103294' \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          --data-ascii "$REQJSON" \
          --compressed \
          "$SITEURL")

        curl \
          --retry 3 --retry-delay 3 \
<<<<<<< HEAD
          --header "Upgrade-Insecure-Requests: 1" \
          --header "$USERAGENT" \
          --header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
          --header "Accept-Language: en-US,en;q=0.9" \
=======
          -H "Host: sw.blackmagicdesign.com" \
          -H "Upgrade-Insecure-Requests: 1" \
          -H "$USERAGENT" \
          -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
          -H "Accept-Language: en-US,en;q=0.9" \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          --compressed \
          "$RESOLVEURL" \
          > $out
      '';

      # The unpack phase won't generate a directory
<<<<<<< HEAD
      sourceRoot = ".";
=======
      setSourceRoot = ''
        sourceRoot=$PWD
      '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD

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
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    }
  );
in
buildFHSEnv {
  name = "davinci-resolve";
  targetPkgs = pkgs: with pkgs; [
<<<<<<< HEAD
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
=======
    librsvg
    libGLU
    libGL
    xorg.libICE
    xorg.libSM
    xorg.libXxf86vm
    xorg.libxcb
    udev
    opencl-headers
    alsa-lib
    xorg.libX11
    xorg.libXext
    expat
    zlib
    libuuid
    bzip2
    libtool
    ocl-icd
    glib
    libarchive
    libxcrypt # provides libcrypt.so.1
    xdg-utils # xdg-open needed to open URLs
    python2
    # currently they want python 3.6 which is EOL
    #python3
    aprutil
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    description = "Professional video editing, color, effects and audio post-processing";
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
=======
    description = "Professional Video Editing, Color, Effects and Audio Post";
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
