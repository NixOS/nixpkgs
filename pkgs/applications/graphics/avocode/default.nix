{ lib, stdenv, makeDesktopItem, fetchurl, unzip
, gdk-pixbuf, glib, gtk3, atk, at-spi2-atk, pango, cairo, freetype, fontconfig, dbus, nss, nspr, alsaLib, cups, expat, udev, gnome3
, xorg, mozjpeg, makeWrapper, wrapGAppsHook, libuuid, at-spi2-core, libdrm, mesa
}:

stdenv.mkDerivation rec {
  pname = "avocode";
  version = "4.11.1";

  src = fetchurl {
    url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
    sha256 = "sha256-Qe5mV9GBLHsmzMQg6dKib/sTnNdyOTj4wYQ9xd/iqJM=";
  };

  libPath = lib.makeLibraryPath (with xorg; [
    stdenv.cc.cc.lib
    at-spi2-core.out
    gdk-pixbuf
    glib
    gtk3
    atk
    at-spi2-atk
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
    libuuid
    libdrm
    mesa
  ]);

  desktopItem = makeDesktopItem {
    name = "Avocode";
    exec = "avocode";
    icon = "avocode";
    desktopName = "Avocode";
    genericName = "Design Inspector";
    categories = "Development;";
    comment = "The bridge between designers and developers";
  };

  nativeBuildInputs = [makeWrapper wrapGAppsHook];
  buildInputs = [ unzip gtk3 gnome3.adwaita-icon-theme ];

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
      patchelf --set-rpath ${libPath}:$out/ $file || true
    done
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://avocode.com/";
    description = "The bridge between designers and developers";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ megheaiulian ];
  };
}
