{ stdenv
, lib
, fetchurl
, mkDerivation
, makeWrapper
, fetchFromGitHub
# Dynamic libraries
, alsaLib
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
, qttools
, pulseaudioSupport ? true, libpulseaudio ? null
}:

assert pulseaudioSupport -> libpulseaudio != null;

let
  version = "5.4.57862.0110";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
      sha256 = "sha256-ZAwXhbZ3nT6PGkSC1vnX2y/XUOZfped0r3OuedI62gY=";
    };
  };
  dontUnpack = true;

  libs = lib.makeLibraryPath ([
    # $ LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$PWD ldd zoom | grep 'not found'
    alsaLib
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

in stdenv.mkDerivation {
  name = "zoom-${version}";

  dontUnpack = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    tar -C $out -xf ${srcs.${stdenv.hostPlatform.system}}
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
    makeWrapper $out/opt/zoom/ZoomLauncher $out/bin/zoom \
      --run "cd $out/opt/zoom" \
      --prefix PATH : ${lib.makeBinPath [ coreutils glib.dev pciutils procps qttools.dev util-linux ]} \
      --prefix LD_LIBRARY_PATH ":" ${libs}

    # Backwards compatiblity: we used to call it zoom-us
    ln -s $out/bin/{zoom,zoom-us}
  '';

  # already done
  dontPatchELF = true;

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://zoom.us/";
    description = "zoom.us video conferencing application";
    license = lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [ danbst tadfisher doronbehar ];
  };
}
