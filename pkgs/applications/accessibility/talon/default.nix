# based on https://github.com/nix-community/talon-nix

{ stdenv
, lib
, curl
, cacert
, requireFile
, makeWrapper
, autoPatchelfHook
, dbus
, fontconfig
, freetype
, glib
, libGL
, libxkbcommon_7
, sqlite
, udev
, xorg
, zlib
, fetchurl
, libpulseaudio
, bzip2
, ncurses5
, gdk-pixbuf
, libuuid
, libdrm
, gtk3-x11
, cairo
, gdbm
, gnome2
, atk
, wayland
, wayland-protocols
, wlroots
, xwayland
, libinput
, libxml2
, speechd
, qt5
, python39
, openssl
, libusb
, callPackage
, useBinaryWav2letter ? true # large dependency
, useBinarySkiaSharp ? true # large dependency
, pkgs
}:

let
  inherit (lib.importJSON ./src.json) version sha256 url mirrorUrls contentLength lastModified;
  # TODO verify: we need talon's custom python3 interpreter to run *.py4 files
  /*
  python3 = python39;
  extraPythonPackages = {
    talon = python3.pkgs.buildPythonPackage {
      pname = "talon";
      inherit (pkgs.talon) version;
      # NOTE: closed source. this has only *.py4 and *.pyi files
      # https://github.com/zrax/pycdc/issues/316
      # py4 looks like talon's custom obfuscation of python *.pyc files
      # the *.py4 files have entropy of 98% = encrypted or compressed
      # see also: dropbox obfuscation
      # https://github.com/kholia/dedrop
      # https://news.ycombinator.com/item?id=13848035
      src = pkgs.talon.src + "/resources/python/lib/python3.9/site-packages/talon";
      dontUnpack = true;
    };
  };
  python3WithPackages = python3.withPackages (pp: with pp; [
    #encodings
    # resources/python/lib/python3.9/site-packages/
    aiohttp
    aiosignal
    #async_timeout
    async-timeout
    attr
    attrs
    bsdiff4
    bson
    certifi
    cffi
    charset-normalizer
    dbus-next
    #distutils-precedence.pth
    frozenlist
    idna
    iniconfig
    lark
    multidict
    numpy
    #numpy.libs
    packaging
    pip
    #pkg_resources
    pluggy
    py
    pycparser
    pyparsing
    pytest
    requests
    setuptools
    #sitecustomize.py
    extraPythonPackages.talon
    toml
    tomli
    urllib3
    wheel
    xcffib
    pyyaml # yaml
    yarl
  ]);
  */
  w2ldecode = callPackage ./w2ldecode.nix { };
  # TODO try latest version of wav2letter in https://github.com/flashlight/flashlight/tree/main/flashlight/app/asr
  # TODO fix build: flashlight, wav2letter, ...
  wav2letter = callPackage ./wav2letter_0_2.nix { };
in

stdenv.mkDerivation rec {
  pname = "talon";
  inherit version;

  # the original url is mutable.
  # when the original url changed, fallback to mirror urls.
  #src = fetchurl { inherit url sha256; }; # this would fail with the original url
  # TODO move fetcher to separate file
  src = stdenv.mkDerivation {
    name = builtins.baseNameOf url;
    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = sha256;
    inherit url mirrorUrls contentLength lastModified;
    phases = "buildPhase";
    nativeBuildInputs = [
      curl
      cacert
    ];
    # test: force download from mirror
    #contentLength=$((contentLength - 1))
    #lastModified="''${lastModified}-old"
    buildPhase = ''
      echo "fetching headers from original url $url ..."
      headers=$(curl -L -I $url)
      echo "headers:"
      echo "$headers"
      # note: -1 to remove trailing \r
      contentLengthActual=$(echo "$headers" | grep "^Content-Length:" | tail -n1)
      contentLengthActual=''${contentLengthActual:16: -1}
      lastModifiedActual=$(echo "$headers" | grep "^Last-Modified:" | tail -n1)
      lastModifiedActual=''${lastModifiedActual:15: -1}

      if [[ "$contentLengthActual" == "$contentLength" && "$lastModifiedActual" == "$lastModified" ]]
      then
        echo "fetching file from original url $url ..."
        curl -L -o $out $url
      else
        echo "note: original url has changed:"
        if [[ "$contentLengthActual" != "$contentLength" ]]; then
          echo "-Content-Length: $contentLength"
          echo "+Content-Length: $contentLengthActual"
        fi
        if [[ "$lastModifiedActual" != "$lastModified" ]]; then
          echo "-Last-Modified: $lastModified"
          echo "+Last-Modified: $lastModifiedActual"
        fi
        for url in "''${mirrorUrls[@]}"; do
          echo "fetching file from mirror $url ..."
          curl -L -o temp $url # TODO keep time?
          stat temp # debug
          contentLengthActual=$(stat -c%s temp)
          if [[ "$contentLengthActual" == "$contentLength" ]]; then
            mv temp $out
            break
          else
            echo "note: mirror url has changed:"
            echo "-Content-Length: $contentLength"
            echo "+Content-Length: $contentLengthActual"
          fi
        done
      fi
    '';
  };

  preferLocalBuild = true;

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    stdenv.cc.cc
    stdenv.cc.libc
    dbus
    fontconfig
    freetype
    glib
    libGL
    libxkbcommon_7
    sqlite
    zlib
    libpulseaudio
    udev
    xorg.libX11
    xorg.libSM
    xorg.libXcursor
    xorg.libICE
    xorg.libXrender
    xorg.libxcb
    xorg.libXext
    xorg.libXcomposite
    bzip2
    ncurses5
    libuuid
    gtk3-x11
    gdk-pixbuf
    cairo
    libdrm
    gnome2.pango
    gdbm
    atk
    wayland
    wayland-protocols
    wlroots
    xwayland
    libinput
    libxml2
    speechd
    qt5.qtbase
    qt5.qtspeech
    qt5.qtx11extras
    openssl.out # default output is openssl.bin
    libusb
    qt5.qtsvg
    qt5.qtgamepad
    #python3WithPackages
    w2ldecode
  ] /*++ (lib.optionals !useBinaryWav2letter [
    # TODO fix build
    wav2letter
  ])*/ /*++ (lib.optionals !useBinarySkiaSharp [
    # TODO add to nixpkgs
    SkiaSharp
  ])*/;

  dontBuild = true;
  dontConfigure = true;

  # TODO use python3 from nixpkgs
  # talon requires libpython3.9.so.1.0 but nixpkgs has python 3.10
  installPhase =  let libPath = lib.makeLibraryPath buildInputs; in ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/etc/udev/rules.d
    mkdir -p $out/share/applications
    mkdir -p $out/opt/talon

    # openssl.out provides: libcrypto.so  libcrypto.so.3  libssl.so  libssl.so.3
    # but talon requires: libssl.so.1.1  libcrypto.so.1.1
    for f in \
      talon \
      resources/python/lib/python3.9/lib-dynload/*.so
    do
      patchelf $f \
        --replace-needed libssl.so.1.1 libssl.so \
        --replace-needed libcrypto.so.1.1 libcrypto.so
    done

    # copy binaries
    cp talon $out/bin
    ${if useBinarySkiaSharp then "cp lib/libSkiaSharp.so $out/lib" else ""}
    ${if useBinaryWav2letter then "cp lib/libw2l-o.so $out/lib" else ""}

    #rm -rf resources/python
    cp -r resources $out/opt/talon/resources

    # based on run.sh
    wrapProgram $out/bin/talon \
      --unset QT_AUTO_SCREEN_SCALE_FACTOR \
      --unset QT_SCALE_FACTOR \
      --set LC_NUMERIC C \
      --set QT_PLUGIN_PATH "$out/lib/plugins" \
      --set LD_LIBRARY_PATH "$out/opt/talon/resources/python/lib/python3.9/site-packages/numpy.libs:$out/lib:$out/opt/talon/resources/python/lib:$out/opt/talon/resources/pypy/lib:${libPath}" \
      --set QT_DEBUG_PLUGINS 1

    # fix the talon repl
    patchelf \
      --interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      $out/opt/talon/resources/python/bin/python3
    # TODO remove?
    wrapProgram "$out/opt/talon/resources/python/bin/python3" \
      --set LD_LIBRARY_PATH ${libPath}
    #rm -rf $out/opt/talon/resources/python
    #ln -v -s $ {python3WithPackages} $out/opt/talon/resources/python

    (
      cd $out/lib
      ln -s ${bzip2.out}/lib/libbz2.so.1 libbz2.so.1.0
      ln -s ${gdbm}/lib/libgdbm.so libgdbm.so.5
    )

    cat >$out/share/applications/talon.desktop <<EOF
    [Desktop Entry]
    Categories=Utility;
    Exec=talon
    Name=Talon
    Terminal=false
    Type=Application
    EOF

    cp 10-talon.rules $out/etc/udev/rules.d
    # Remove udev compatibility hack using plugdev for older debian/ubuntu
    # This breaks NixOS usage of these rules (see https://github.com/NixOS/nixpkgs/issues/76482)
    substituteInPlace $out/etc/udev/rules.d/10-talon.rules --replace 'GROUP="plugdev",' ""

    runHook postInstall
  '';

  meta = {
    homepage = "https://talonvoice.com/";
    description = "Voice coding application";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.linux;
  };

  passthru = {
    inherit w2ldecode wav2letter;
  };
}
