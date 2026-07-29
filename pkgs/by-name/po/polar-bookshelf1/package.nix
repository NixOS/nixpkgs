{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  at-spi2-atk,
  atk,
  autoPatchelfHook,
  cairo,
  cups,
  curl,
  dbus,
  dpkg,
  expat,
  fontconfig,
  gdk-pixbuf,
  glib,
  glibc,
  gsettings-desktop-schemas,
  gtk3,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libnghttp2,
  libudev0-shim,
  libxcb,
  makeWrapper,
  nspr,
  nss,
  openssl,
  pango,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "polar-bookshelf1";
  version = "1.100.13";

  src = fetchurl {
    url = "mirror://sourceforge/polar-bookshelf.mirror/v${finalAttrs.version}/polar-bookshelf-${finalAttrs.version}-amd64.deb";
    hash = "sha256-TeegAq3x8LZ01KEPIlP4lTGC0a9ilnf1xX/Dqci1wEQ=";
  };

  buildInputs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    gdk-pixbuf
    glib
    gsettings-desktop-schemas
    gtk3
    libx11
    libxscrnsaver
    libxcomposite
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxi
    libxrandr
    libxrender
    libxtst
    libxcb
    nspr
    nss
    pango
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  runtimeLibs = lib.makeLibraryPath [
    libudev0-shim
    glibc
    curl
    openssl
    libnghttp2
  ];

  installPhase = ''
    mkdir -p $out/share/polar-bookshelf $out/bin $out/lib
    mv opt/Polar\ Bookshelf/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib
    mv usr/share/* $out/share/
    ln -s $out/share/polar-bookshelf/polar-bookshelf $out/bin/polar-bookshelf
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${finalAttrs.runtimeLibs}" )
    # Correct desktop file `Exec`
    substituteInPlace $out/share/applications/polar-bookshelf.desktop \
      --replace "/opt/Polar Bookshelf/polar-bookshelf" "$out/bin/polar-bookshelf"
  '';

  meta = {
    homepage = "https://getpolarized.io/";
    description = "Personal knowledge repository for PDF and web content supporting incremental reading and document annotation";
    mainProgram = "polar-bookshelf";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dansbandit ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
