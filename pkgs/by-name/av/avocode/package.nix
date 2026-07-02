{
  lib,
  stdenv,
  makeDesktopItem,
  fetchurl,
  unzip,
  gdk-pixbuf,
  glib,
  gtk3,
  atk,
  at-spi2-atk,
  pango,
  cairo,
  freetype,
  fontconfig,
  dbus,
  nss,
  nspr,
  alsa-lib,
  cups,
  expat,
  udev,
  adwaita-icon-theme,
  libxtst,
  libxscrnsaver,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxshmfence,
  libxcb,
  mozjpeg,
  makeWrapper,
  wrapGAppsHook3,
  libuuid,
  at-spi2-core,
  libdrm,
  libgbm,
  libxkbcommon,
}:

stdenv.mkDerivation rec {
  pname = "avocode";
  version = "4.15.6";

  src = fetchurl {
    url = "https://media.avocode.com/download/avocode-app/${version}/avocode-${version}-linux.zip";
    sha256 = "sha256-vNQT4jyMIIAk1pV3Hrp40nawFutWCv7xtwg2gU6ejy0=";
  };

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
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
    libx11
    libxcb
    libxshmfence
    libxkbcommon
    libxi
    libxcursor
    libxdamage
    libxrandr
    libxcomposite
    libxext
    libxfixes
    libxrender
    libxtst
    libxscrnsaver
    libuuid
    libdrm
    libgbm
  ];

  desktopItem = makeDesktopItem {
    name = "Avocode";
    exec = "avocode";
    icon = "avocode";
    desktopName = "Avocode";
    genericName = "Design Inspector";
    categories = [ "Development" ];
    comment = "The bridge between designers and developers";
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    unzip
  ];
  buildInputs = [
    gtk3
    adwaita-icon-theme
  ];

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

  meta = {
    homepage = "https://avocode.com/";
    description = "Bridge between designers and developers";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ megheaiulian ];
  };
}
