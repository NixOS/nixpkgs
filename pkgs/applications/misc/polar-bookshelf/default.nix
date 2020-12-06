{ stdenv, lib, makeWrapper, fetchurl
, dpkg, wrapGAppsHook, autoPatchelfHook
, gtk3, cairo, pango, atk, gdk-pixbuf, glib
, at-spi2-atk, dbus, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver
, nss, nspr, alsaLib, cups, fontconfig, expat
, libudev0-shim, glibc, curl, openssl, libnghttp2, gsettings-desktop-schemas }:


stdenv.mkDerivation rec {
  pname = "polar-bookshelf";
  version = "2.0.42";

  # fetching a .deb because there's no easy way to package this Electron app
  src = fetchurl {
    url = "https://github.com/burtonator/polar-bookshelf/releases/download/v${version}/polar-desktop-app-${version}-amd64.deb";
    hash = "sha256-JyO71wyE6b0iHAYs/6/WbG+OdUVUUPpJla+ZUzg0Gng=";
  };

  buildInputs = [
    gsettings-desktop-schemas
    glib
    gtk3
    cairo
    pango
    atk
    gdk-pixbuf
    at-spi2-atk
    dbus
    libX11
    libxcb
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libXtst
    libXScrnSaver
    nss
    nspr
    alsaLib
    cups
    fontconfig
    expat
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];

  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl openssl libnghttp2 ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/polar-bookshelf
    mkdir -p $out/bin
    mkdir -p $out/lib

    mv opt/Polar/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib

    mv usr/share/* $out/share/

    ln -s $out/share/polar-bookshelf/polar-desktop-app $out/bin/polar-desktop-app

    substituteInPlace $out/share/applications/polar-desktop-app.desktop \
      --replace "/opt/Polar/polar-desktop-app" "$out/bin/polar-desktop-app"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  meta = {
    homepage = "https://getpolarized.io/";
    description = "Personal knowledge repository for PDF and web content supporting incremental reading and document annotation";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.noneucat ];
  };

}
