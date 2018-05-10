{ stdenv, fetchurl, system, makeWrapper, makeDesktopItem,
  alsaLib, dbus, glib, fontconfig, freetype, libpulseaudio,
  utillinux, zlib, xorg, udev, sqlite, expat, libv4l, procps, libGL }:

let

  version = "2.0.123200.0405";
  srcs = {
    x86_64-linux = fetchurl {
      url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
      sha256 = "1ifwa2xf5mw1ll2j1f39qd7mpyxpc6xj3650dmlnxf525dsm573z";
    };
  };

in stdenv.mkDerivation {
  name = "zoom-us-${version}";

  src = srcs.${system};

  nativeBuildInputs = [ makeWrapper ];

  libPath = stdenv.lib.makeLibraryPath [
    alsaLib
    expat
    glib
    freetype
    libGL
    libpulseaudio
    zlib
    dbus
    fontconfig
    sqlite
    utillinux
    udev

    xorg.libX11
    xorg.libSM
    xorg.libICE
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.libXcursor
    xorg.libXext
    xorg.libXfixes
    xorg.libXdamage
    xorg.libXtst
    xorg.libxshmfence
    xorg.libXi
    xorg.libXrender
    xorg.libXcomposite
    xorg.libXScrnSaver
    xorg.libXrandr

    stdenv.cc.cc
  ];

  installPhase = ''
    runHook preInstall

    packagePath=$out/share/zoom-us
    mkdir -p $packagePath
    mkdir -p $out/bin
    cp -ar * $packagePath

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  $packagePath/zoom
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  $packagePath/QtWebEngineProcess
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  $packagePath/qtdiag
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)"  $packagePath/zopen
    # included from https://github.com/NixOS/nixpkgs/commit/fc218766333a05c9352b386e0cbb16e1ae84bf53
    # it works for me without it, but, well...
    paxmark m $packagePath/zoom
    #paxmark m $packagePath/QtWebEngineProcess # is this what dtzWill talked about?

    # RUNPATH set via patchelf is used only for half of libraries (why?), so wrap it
    makeWrapper $packagePath/zoom $out/bin/zoom-us \
        --prefix LD_LIBRARY_PATH : "$packagePath:$libPath" \
        --prefix LD_PRELOAD : "${libv4l}/lib/v4l1compat.so" \
        --prefix PATH : "${procps}/bin" \
        --set QT_PLUGIN_PATH "$packagePath/platforms" \
        --set QT_XKB_CONFIG_ROOT "${xorg.xkeyboardconfig}/share/X11/xkb" \
        --set QTCOMPOSE "${xorg.libX11.out}/share/X11/locale"

    cat > $packagePath/qt.conf <<EOF
    [Paths]
    Prefix = $packagePath
    EOF

    runHook postInstall
  '';

  postInstall = (makeDesktopItem {
    name = "zoom-us";
    exec = "$out/bin/zoom-us %U";
    icon = "$out/share/zoom-us/application-x-zoom.png";
    desktopName = "Zoom";
    genericName = "Video Conference";
    categories = "Network;Application;";
    mimeType = "x-scheme-handler/zoommtg;";
  }).buildCommand;

  meta = {
    homepage = https://zoom.us/;
    description = "zoom.us video conferencing application";
    license = stdenv.lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with stdenv.lib.maintainers; [ danbst ];
  };

}
