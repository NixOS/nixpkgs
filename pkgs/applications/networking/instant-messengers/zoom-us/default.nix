{ stdenv
, lib
, fetchurl
, makeWrapper
, xar
, cpio
  # Dynamic libraries
, alsa-lib
, atk
, at-spi2-atk
, at-spi2-core
, cairo
, cups
, dbus
, expat
, libdrm
, libGL
, fontconfig
, freetype
, gtk3
, gdk-pixbuf
, glib
, mesa
, nspr
, nss
, pango
, wayland
, xorg
, libxkbcommon
, udev
, zlib
  # Runtime
, coreutils
, pciutils
, procps
, util-linux
, pulseaudioSupport ? true
, libpulseaudio
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  # Zoom versions are released at different times for each platform
  version = {
    aarch64-darwin = "5.10.4.6592";
    x86_64-darwin = "5.10.4.6592";
    x86_64-linux = "5.10.6.3192";
   }.${system} or throwSystem;

  srcs = {
    aarch64-darwin = fetchurl {
       url = "https://zoom.us/client/${version}/Zoom.pkg?archType=arm64";
       sha256 = "0jg5f9hvb67hhfnifpx5fzz65fcijldy1znlia6pqflxwci3m5rq";
    };
    x86_64-darwin = fetchurl {
      url = "https://zoom.us/client/${version}/Zoom.pkg";
      sha256 = "1p83691bid8kz5mw09x6l9zvjglfszi5vbhfmbbpiqhiqcxlfz83";
    };
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
      sha256 = "8QIkF5+875VFoGK6T0CROsqML6bJDG934c1gkuz8Klk=";
    };
  };

  libs = lib.makeLibraryPath ([
    # $ LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD ldd zoom | grep 'not found'
    alsa-lib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    libdrm
    libGL
    fontconfig
    freetype
    gtk3
    gdk-pixbuf
    glib
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    libxkbcommon
    xorg.libXrandr
    xorg.libXrender
    xorg.libxshmfence
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.libXfixes
    xorg.libXtst
    udev
    zlib
  ] ++ lib.optional (pulseaudioSupport) libpulseaudio);

in
stdenv.mkDerivation rec {
  pname = "zoom";
  inherit version;

  src = srcs.${system} or throwSystem;

  dontUnpack = stdenv.isLinux;
  unpackPhase = lib.optionalString stdenv.isDarwin ''
    xar -xf $src
    zcat < zoomus.pkg/Payload | cpio -i
  '';

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.isDarwin [
    xar
    cpio
  ];

  installPhase = ''
    runHook preInstall
    ${rec {
      aarch64-darwin = ''
        mkdir -p $out/Applications
        cp -R zoom.us.app $out/Applications/
      '';
      # darwin steps same on both architectures
      x86_64-darwin = aarch64-darwin;
      x86_64-linux = ''
        mkdir $out
        tar -C $out -xf $src
        mv $out/usr/* $out/
      '';
    }.${system} or throwSystem}
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # Desktop File
    substituteInPlace $out/share/applications/Zoom.desktop \
        --replace "Exec=/usr/bin/zoom" "Exec=$out/bin/zoom"

    for i in zopen zoom ZoomLauncher; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zoom/$i
    done

    # ZoomLauncher sets LD_LIBRARY_PATH before execing zoom
    # IPC breaks if the executable name does not end in 'zoom'
    mv $out/opt/zoom/zoom $out/opt/zoom/.zoom
    makeWrapper $out/opt/zoom/.zoom $out/opt/zoom/zoom \
      --prefix LD_LIBRARY_PATH ":" ${libs}

    rm $out/bin/zoom
    # Zoom expects "zopen" executable (needed for web login) to be present in CWD. Or does it expect
    # everybody runs Zoom only after cd to Zoom package directory? Anyway, :facepalm:
    # Clear Qt paths to prevent tripping over "foreign" Qt resources.
    # Clear Qt screen scaling settings to prevent over-scaling.
    makeWrapper $out/opt/zoom/ZoomLauncher $out/bin/zoom \
      --chdir "$out/opt/zoom" \
      --unset QML2_IMPORT_PATH \
      --unset QT_PLUGIN_PATH \
      --unset QT_SCREEN_SCALE_FACTORS \
      --prefix PATH : ${lib.makeBinPath [ coreutils glib.dev pciutils procps util-linux ]} \
      --prefix LD_LIBRARY_PATH ":" ${libs}

    # Backwards compatiblity: we used to call it zoom-us
    ln -s $out/bin/{zoom,zoom-us}
  '';

  # already done
  dontPatchELF = true;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://zoom.us/";
    description = "zoom.us video conferencing application";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ danbst tadfisher doronbehar ];
  };
}
