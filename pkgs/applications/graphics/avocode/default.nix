{ lib, stdenv, makeDesktopItem, fetchurl, unzip
, gdk-pixbuf, glib, gtk3, atk, at-spi2-atk, pango, cairo, freetype, fontconfig, dbus, nss, nspr, alsa-lib, cups, expat, udev, adwaita-icon-theme
, xorg, mozjpeg, makeWrapper, wrapGAppsHook3, libuuid, at-spi2-core, libdrm, mesa, libxkbcommon
}:

stdenv.mkDerivation rec {
  pname = "avocode";
  version = "4.15.6";

  src = fetchurl {
    url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
    sha256 = "sha256-vNQT4jyMIIAk1pV3Hrp40nawFutWCv7xtwg2gU6ejy0=";
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
    alsa-lib
    cups
    expat
    udev
    libX11
    libxcb
    libxshmfence
    libxkbcommon
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
    categories = [ "Development" ];
    comment = "The bridge between designers and developers";
  };

  nativeBuildInputs = [makeWrapper wrapGAppsHook3 unzip];
  buildInputs = [ gtk3 adwaita-icon-theme ];

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
    description = "Bridge between designers and developers";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = with maintainers; [ megheaiulian ];
  };
}
