{ stdenv, lib, makeWrapper, fetchurl
, dpkg, wrapGAppsHook
, gtk3, cairo, gnome2, atk, gdk_pixbuf, glib
, at-spi2-atk, dbus, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver
, nss, nspr, alsaLib, cups, fontconfig, expat
, libudev0-shim, glibc, curl, openssl, nghttp2, gsettings_desktop_schemas }:


stdenv.mkDerivation rec {
  name = "polar-bookshelf-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "https://github.com/burtonator/polar-bookshelf/releases/download/${version}/polar-bookshelf-${version}-amd64.deb";
    sha256 = "0fz34qvd7zp5rd5rqljwhq8ya9x29cq5h8axb82z369nkbi1xpbs";
  };

  buildInputs = [
    gsettings_desktop_schemas
    glib
    gtk3
  ];

  nativeBuildInputs = [ 
    wrapGAppsHook
    makeWrapper 
    dpkg
  ];

  libPath = lib.makeLibraryPath [
      gtk3
      cairo
      gnome2.pango
      atk
      gdk_pixbuf
      glib
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

  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl openssl nghttp2 ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/share/polar-bookshelf
    mkdir -p $out/bin
    mkdir -p $out/lib

    mv opt/Polar\ Bookshelf/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib

    mv usr/share/* $out/share/

    ln -s $out/share/polar-bookshelf/polar-bookshelf $out/bin/polar-bookshelf
  '';

  preFixup = ''
    for lib in $out/lib/*.so; do
      patchelf --set-rpath "$out/lib:${libPath}" $lib
    done

    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath "$out/lib:${libPath}" \
             $out/bin/polar-bookshelf 

    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  meta = {
    homepage = https://getpolarized.io/;
    description = "Personal knowledge repository for PDF and web content supporting incremental reading and document annotation.";
    license = stdenv.lib.licenses.gpl1Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.noneucat ];
  };

}