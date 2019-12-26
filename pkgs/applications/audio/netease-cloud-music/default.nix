{ stdenv, lib, fontconfig, zlib, libGL, glib, pango
, gdk-pixbuf, freetype, atk, cairo, libsForQt5, xorg
, sqlite, taglib, nss, nspr, cups, dbus, alsaLib
, libpulseaudio, deepin, qt5, harfbuzz, p11-kit
, libgpgerror, libudev0-shim, makeWrapper, dpkg, fetchurl }:
let
  rpath = lib.makeLibraryPath [
    fontconfig.lib
    zlib
    stdenv.cc.cc.lib
    libGL
    glib
    pango
    gdk-pixbuf
    freetype
    atk
    cairo
    libsForQt5.vlc
    sqlite
    taglib
    nss
    nspr
    cups.lib
    dbus.lib
    alsaLib
    libpulseaudio
    xorg.libX11
    xorg.libXext
    xorg.libXtst
    xorg.libXdamage
    xorg.libXScrnSaver
    xorg.libxcb
    xorg.libXi
    deepin.qcef
    qt5.qtwebchannel
    qt5.qtbase
    qt5.qtx11extras
    qt5.qtdeclarative
    harfbuzz
    p11-kit
    libgpgerror
  ];   

  runtimeLibs = lib.makeLibraryPath [ libudev0-shim ];

in stdenv.mkDerivation rec {
  pname = "netease-cloud-music";
  version = "1.2.0";
  src = fetchurl {
    url    = "http://d1.music.126.net/dmusic/netease-cloud-music_1.2.0_amd64_deepin_stable_20190424.deb";
    sha256 = "0hg8jqim77vd0fmk8gfbz2fmlj99byxcm9jn70xf7vk1sy7wp6h1";
    curlOpts = "-A 'Mozilla/5.0'";
  };
  unpackCmd = "${dpkg}/bin/dpkg -x $src .";
  sourceRoot = ".";

  nativeBuildInputs = [ qt5.wrapQtAppsHook makeWrapper ];

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
  '';

  preFixup = ''
    local exefile="$out/bin/netease-cloud-music"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$exefile"
    patchelf --set-rpath "$out/libs:$(patchelf --print-rpath "$exefile"):${rpath}" "$exefile"

    wrapProgram $out/bin/netease-cloud-music \
      --prefix LD_LIBRARY_PATH : "${runtimeLibs}" \
      --set QT_AUTO_SCREEN_SCALE_FACTOR 1 \
      --set QCEF_INSTALL_PATH "${deepin.qcef}/lib/qcef"
  '';

  meta = {
    description = "Client for Netease Cloud Music service";
    homepage = https://music.163.com;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.mlatus ];
    license = stdenv.lib.licenses.unfreeRedistributable;
  };
}
