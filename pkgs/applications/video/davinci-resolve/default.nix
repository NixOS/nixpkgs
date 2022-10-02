{ stdenv
, lib
, cacert
, curl
, runCommandLocal
, targetPlatform
, unzip
, appimage-run
, addOpenGLRunpath
, libGLU
, xorg
, buildFHSUserEnv
, bash
, writeText
, ocl-icd
, xkeyboard_config
, glib
, libarchive
, python2
}:

let
  davinci = (
    stdenv.mkDerivation rec {
      pname = "davinci-resolve";
      version = "17.4.3";

      nativeBuildInputs = [ unzip appimage-run addOpenGLRunpath ];

      # Pretty sure, there are missing dependencies ...
      buildInputs = [ libGLU xorg.libXxf86vm ];

      src = runCommandLocal "${pname}-src.zip"
        rec {
          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = "0hq374n26mbcds8f1z644cvnh4h2rjdrbxxxbj4p34mx9b04ab28";

          impureEnvVars = lib.fetchers.proxyImpureEnvVars;

          nativeBuildInputs = [ curl ];

          # ENV VARS
          SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

          DOWNLOADID = "5efad1a052e8471989f662338d5247f1";
          REFERID = "263d62f31cbb49e0868005059abcb0c9";
          SITEURL = "https://www.blackmagicdesign.com/api/register/us/download/${DOWNLOADID}";

          USERAGENT = builtins.concatStringsSep " " [
            "User-Agent: Mozilla/5.0 (X11; Linux ${targetPlatform.linuxArch})"
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
            "state" = "Province of Utrecht";
            "city" = "Utrecht";
            "product" = "DaVinci Resolve";
          };

        } ''
        RESOLVEURL=$(curl \
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
          --data-ascii "$REQJSON" \
          --compressed \
          "$SITEURL")

        curl \
          --retry 3 --retry-delay 3 \
          -H "Host: sw.blackmagicdesign.com" \
          -H "Upgrade-Insecure-Requests: 1" \
          -H "$USERAGENT" \
          -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8" \
          -H "Accept-Language: en-US,en;q=0.9" \
          --compressed \
          "$RESOLVEURL" \
          > $out
      '';

      # The unpack phase won't generate a directory
      setSourceRoot = ''
        sourceRoot=$PWD
      '';

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
      '';
    }
  );
in
buildFHSUserEnv {
  name = "davinci-resolve";
  targetPkgs = pkgs: with pkgs; [
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
    xdg-utils # xdg-open needed to open URLs
    python2
    # currently they want python 3.6 which is EOL
    #python3
  ];

  runScript = "${bash}/bin/bash ${
    writeText "davinci-wrapper"
    ''
    export QT_XKB_CONFIG_ROOT="${xkeyboard_config}/share/X11/xkb"
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${davinci}/libs
    ${davinci}/bin/resolve
    ''
  }";

  meta = with lib; {
    description = "Professional Video Editing, Color, Effects and Audio Post";
    homepage = "https://www.blackmagicdesign.com/products/davinciresolve/";
    license = licenses.unfree;
    maintainers = with maintainers; [ jshcmpbll ];
    platforms = platforms.linux;
  };
}
