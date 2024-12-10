{
  stdenv,
  lib,
  fetchurl,
  rpmextract,
  libnotify,
  libuuid,
  cairo,
  cups,
  pango,
  fontconfig,
  udev,
  dbus,
  gtk3,
  atk,
  at-spi2-atk,
  expat,
  gdk-pixbuf,
  freetype,
  nspr,
  glib,
  nss,
  libX11,
  libXrandr,
  libXrender,
  libXtst,
  libXdamage,
  libxcb,
  libXcursor,
  libXi,
  libXext,
  libXfixes,
  libXft,
  libXcomposite,
  libXScrnSaver,
  alsa-lib,
  pulseaudio,
  makeWrapper,
  xdg-utils,
}:

let
  getFirst = n: v: builtins.concatStringsSep "." (lib.take n (lib.splitString "." v));
in

stdenv.mkDerivation rec {
  pname = "bluejeans";
  version = "2.32.1.3";

  src = fetchurl {
    url = "https://swdl.bluejeans.com/desktop-app/linux/${getFirst 3 version}/BlueJeans_${version}.rpm";
    sha256 = "sha256-lsUS7JymCMOa5wlWJOwLFm4KRnAYixi9Kk5CYHB17Ac=";
  };

  nativeBuildInputs = [
    rpmextract
    makeWrapper
  ];

  libPath = lib.makeLibraryPath [
    libnotify
    libuuid
    cairo
    cups
    pango
    fontconfig
    gtk3
    atk
    at-spi2-atk
    expat
    gdk-pixbuf
    dbus
    (lib.getLib udev)
    freetype
    nspr
    glib
    stdenv.cc.cc
    nss
    libX11
    libXrandr
    libXrender
    libXtst
    libXdamage
    libxcb
    libXcursor
    libXi
    libXext
    libXfixes
    libXft
    libXcomposite
    libXScrnSaver
    alsa-lib
    pulseaudio
  ];

  localtime64_stub = ./localtime64_stub.c;

  buildCommand = ''
    mkdir -p $out/bin/
    cd $out
    rpmextract $src
    mv usr/share share
    rmdir usr

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --replace-needed libudev.so.0 libudev.so.1 \
      opt/BlueJeans/bluejeans-v2

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      opt/BlueJeans/resources/BluejeansHelper

    cc $localtime64_stub -shared -o "${placeholder "out"}"/opt/BlueJeans/liblocaltime64_stub.so

    # make xdg-open overrideable at runtime
    makeWrapper $out/opt/BlueJeans/bluejeans-v2 $out/bin/bluejeans \
      --set LD_LIBRARY_PATH "${libPath}":"${placeholder "out"}"/opt/BlueJeans \
      --set LD_PRELOAD "$out"/opt/BlueJeans/liblocaltime64_stub.so \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]}

    substituteInPlace "$out"/share/applications/bluejeans-v2.desktop \
      --replace "/opt/BlueJeans/bluejeans-v2" "$out/bin/bluejeans"

    patchShebangs "$out"
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Video, audio, and web conferencing that works together with the collaboration tools you use every day";
    homepage = "https://www.bluejeans.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
  };
}
