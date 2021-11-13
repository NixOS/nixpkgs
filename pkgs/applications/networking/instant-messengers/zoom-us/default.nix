{ stdenv
, lib
, fetchurl
, makeWrapper
  # Dynamic libraries
, alsa-lib
, atk
, cairo
, dbus
, libGL
, fontconfig
, freetype
, gtk3
, gdk-pixbuf
, glib
, pango
, wayland
, xorg
, libxkbcommon
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
  version = "5.8.3.145";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
      sha256 = "1p4agpbcpk95r04m775dr17fmlm18vxq9mb65pyfbhvsd1ypw6kr";
    };
  };

  libs = lib.makeLibraryPath ([
    # $ LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD ldd zoom | grep 'not found'
    alsa-lib
    atk
    cairo
    dbus
    libGL
    fontconfig
    freetype
    gtk3
    gdk-pixbuf
    glib
    pango
    stdenv.cc.cc
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXext
    libxkbcommon
    xorg.libXrender
    zlib
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.libXfixes
    xorg.libXtst
  ] ++ lib.optional (pulseaudioSupport) libpulseaudio);

in
stdenv.mkDerivation rec {
  pname = "zoom";
  inherit version;

  src = srcs.${stdenv.hostPlatform.system};

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    tar -C $out -xf $src
    mv $out/usr/* $out/
    runHook postInstall
  '';

  postFixup = ''
    # Desktop File
    substituteInPlace $out/share/applications/Zoom.desktop \
        --replace "Exec=/usr/bin/zoom" "Exec=$out/bin/zoom"

    for i in zopen zoom ZoomLauncher; do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zoom/$i
    done

    # ZoomLauncher sets LD_LIBRARY_PATH before execing zoom
    wrapProgram $out/opt/zoom/zoom \
      --prefix LD_LIBRARY_PATH ":" ${libs}

    rm $out/bin/zoom
    # Zoom expects "zopen" executable (needed for web login) to be present in CWD. Or does it expect
    # everybody runs Zoom only after cd to Zoom package directory? Anyway, :facepalm:
    # Clear Qt paths to prevent tripping over "foreign" Qt resources.
    # Clear Qt screen scaling settings to prevent over-scaling.
    makeWrapper $out/opt/zoom/ZoomLauncher $out/bin/zoom \
      --run "cd $out/opt/zoom" \
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
    license = licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [ danbst tadfisher doronbehar ];
  };
}
