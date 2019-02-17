{ stdenv, lib, makeWrapper, fetchurl
, dpkg, wrapGAppsHook, autoPatchelfHook
, gtk3, cairo, gnome2, atk, gdk_pixbuf, glib
, at-spi2-atk, dbus, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite
, libXext, libXfixes, libXrender, libXtst, libXScrnSaver
, nss, nspr, alsaLib, cups, fontconfig, expat
, libudev0-shim, glibc, curl, openssl, libnghttp2, gnome3 }:


stdenv.mkDerivation rec {
  name = "polar-bookshelf-${version}";
  version = "1.12.0";

  # fetching a .deb because there's no easy way to package this Electron app
  src = fetchurl {
    url = "https://github.com/burtonator/polar-bookshelf/releases/download/v${version}/polar-bookshelf-${version}-amd64.deb";
    sha256 = "058pl54mkbvcjyjmdz81r0ibk1qkc3798pkkdw1kp2cbg16qkfyh";
  };

  buildInputs = [
    gnome3.gsettings_desktop_schemas
    glib
    gtk3
    cairo
    gnome2.pango
    atk
    gdk_pixbuf
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

    mv opt/Polar\ Bookshelf/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib

    mv usr/share/* $out/share/

    ln -s $out/share/polar-bookshelf/polar-bookshelf $out/bin/polar-bookshelf
    
    # Correct desktop file `Exec`
    substituteInPlace $out/share/applications/polar-bookshelf.desktop \
      --replace "/opt/Polar Bookshelf/polar-bookshelf" "$out/bin/polar-bookshelf"
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  meta = {
    homepage = https://getpolarized.io/;
    description = "Personal knowledge repository for PDF and web content supporting incremental reading and document annotation";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.noneucat ];
  };

}
