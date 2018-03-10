{ stdenv, lib, libXcomposite, libgnome-keyring, makeWrapper, udev, curl, alsaLib
, libXfixes, atk, gtk2, libXrender, pango, gnome2, cairo, freetype, fontconfig
, libX11, libXi, libxcb, libXext, libXcursor, glib, libXScrnSaver, libxkbfile, libXtst
, nss, nspr, cups, fetchurl, expat, gdk_pixbuf, libXdamage, libXrandr, dbus
, dpkg, makeDesktopItem
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "gitkraken-${version}";
  version = "3.3.4";

  src = fetchurl {
    url = "https://release.gitkraken.com/linux/v${version}.deb";
    sha256 = "1djrbpm1f258cicf65ddvndpxi1izmnc12253k1zwl77z4jjbwls";
  };

  libPath = makeLibraryPath [
    stdenv.cc.cc.lib
    curl
    udev
    libX11
    libXext
    libXcursor
    libXi
    libxcb
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

  unpackPhase = "true";
  buildCommand = ''
    mkdir -p $out
    dpkg -x $src $out
    substituteInPlace $out/usr/share/applications/gitkraken.desktop \
      --replace /usr/share/gitkraken $out/bin
    cp -av $out/usr/* $out
    rm -rf $out/etc $out/usr $out/share/lintian
    chmod -R g-w $out

    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${libPath}:$out/share/gitkraken $file || true
    done

    find $out/share/gitkraken -name "*.node" -exec patchelf --set-rpath "${libPath}:$out/share/gitkraken" {} \;

    rm $out/bin/gitkraken
    ln -s $out/share/gitkraken/gitkraken $out/bin/gitkraken
  '';

  meta = {
    homepage = https://www.gitkraken.com/;
    description = "The downright luxurious and most popular Git client for Windows, Mac & Linux";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xnwdd ];
  };
}
