{ stdenv, makeDesktopItem, fetchurl, unzip
, gdk_pixbuf, glib, gtk2, atk, pango, cairo, freetype, fontconfig, dbus, nss, nspr, alsaLib, cups, expat, udev, gnome2
, xorg, mozjpeg
}:

stdenv.mkDerivation rec {
  name = "avocode-${version}";
  version = "3.4.0";

  src = fetchurl {
    url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
    sha256 = "1dk4vgam9r5nl8dvpfwrn52gq6r4zxs4zz63p3c4gk73d8qnh4dl";
  };

  libPath = stdenv.lib.makeLibraryPath (with xorg; with gnome2; [
    stdenv.cc.cc.lib
    gdk_pixbuf
    glib
    gtk2
    atk
    pango
    cairo
    freetype
    fontconfig
    dbus
    nss
    nspr
    alsaLib
    cups
    expat
    udev
    GConf
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
  ]);

  desktopItem = makeDesktopItem {
    name = "Avocode";
    exec = "avocode";
    icon = "avocode";
    desktopName = "Avocode";
    genericName = "Design Inspector";
    categories = "Application;Development;";
    comment = "The bridge between designers and developers";
  };

  buildInputs = [ unzip ];

  # src is producing multiple folder on unzip so we must
  # override unpackCmd to extract it into newly created folder
  unpackCmd = ''
    mkdir out
    unzip $curSrc -d out
  '';

  installPhase = ''
    substituteInPlace avocode.desktop.in \
      --replace /path/to/avocode-dir/Avocode $out/bin/avocode \
      --replace /path/to/avocode-dir/avocode.png avocode

    mkdir -p share/applications share/pixmaps
    mv avocode.desktop.in share/applications/avocode.desktop
    mv avocode.png share/pixmaps/

    rm resources/cjpeg
    cp -av . $out

    mkdir $out/bin
    ln -s $out/avocode $out/bin/avocode
    ln -s ${mozjpeg}/bin/cjpeg $out/resources/cjpeg
  '';

  postFixup = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/avocode
    for file in $(find $out -type f \( -perm /0111 -o -name \*.so\* \) ); do
      patchelf --set-rpath ${libPath}:$out/ $file
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://avocode.com/;
    description = "The bridge between designers and developers";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ megheaiulian ];
  };
}
