{ stdenv, lib, libXcomposite, libgnome-keyring, makeWrapper, udev, curl, alsaLib
, libXfixes, atk, gtk2, libXrender, pango, gnome2, cairo, freetype, fontconfig
, libX11, libXi, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchurl, expat, gdk_pixbuf, libXdamage, libXrandr, dbus
, dpkg, makeDesktopItem
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gitkraken-${version}";
  version = "2.7.0";

  src = fetchurl {
    url = "https://release.gitkraken.com/linux/v${version}.deb";
    sha256 = "0088vdn47563f0v9zhk1vggn3c2cfg8rhmifc6nw4zbss49si5gp";
  };

  libPath = makeLibraryPath [
    stdenv.cc.cc.lib
    curl
    udev
    libX11
    libXext
    libXcursor
    libXi
    glib
    libXScrnSaver
    libxkbfile
    libXtst
    nss
    nspr
    cups
    alsaLib
    expat
    gdk_pixbuf
    dbus
    libXdamage
    libXrandr
    atk
    pango
    cairo
    freetype
    fontconfig
    libXcomposite
    libXfixes
    libXrender
    gtk2
    gnome2.GConf
    libgnome-keyring
  ];

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  desktopItem = makeDesktopItem {
    name = "gitkraken";
    exec = "gitkraken";
    icon = "app";
    desktopName = "GitKraken";
    genericName = "Git Client";
    categories = "Application;Development;";
    comment = "Graphical Git client from Axosoft";
  };

  buildInputs = [ dpkg ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p "$out/opt/gitkraken"
    cp -r usr/share/gitkraken/* "$out/opt/gitkraken"

    mkdir -p "$out/share/applications"
    cp $desktopItem/share/applications/* "$out/share/applications"

    mkdir -p "$out/share/pixmaps"
    cp usr/share/pixmaps/app.png "$out/share/pixmaps"
  '';

  postFixup = ''
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath "$libPath:$out/opt/gitkraken" "$out/opt/gitkraken/gitkraken"
    wrapProgram $out/opt/gitkraken/gitkraken \
      --prefix LD_PRELOAD : "${makeLibraryPath [ curl ]}/libcurl.so.4" \
      --prefix LD_PRELOAD : "${makeLibraryPath [ libgnome-keyring ]}/libgnome-keyring.so.0"
    mkdir "$out/bin"
    ln -s "$out/opt/gitkraken/gitkraken" "$out/bin/gitkraken"
  '';

  meta = {
    homepage = https://www.gitkraken.com/;
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd ];
  };
}
