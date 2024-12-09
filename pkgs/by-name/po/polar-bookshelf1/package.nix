{ lib
, stdenv
, fetchurl
, alsa-lib
, at-spi2-atk
, atk
, autoPatchelfHook
, cairo
, cups
, curl
, dbus
, dpkg
, expat
, fontconfig
, gdk-pixbuf
, glib
, glibc
, gsettings-desktop-schemas
, gtk3
, libX11
, libXScrnSaver
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXfixes
, libXi
, libXrandr
, libXrender
, libXtst
, libnghttp2
, libudev0-shim
, libxcb
, makeWrapper
, nspr
, nss
, openssl
, pango
, wrapGAppsHook3
}:

stdenv.mkDerivation rec {
  pname = "polar-bookshelf1";
  version = "1.100.14";

  src = fetchurl {
    url = "https://github.com/burtonator/polar-bookshelf/releases/download/v${version}/polar-bookshelf-${version}-amd64.deb";
    hash = "sha256-5xa+Nwu0p1x5DLn1GNI0HDt7GtBGoFQ/9qGTeq9uBgU=";
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
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
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

  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc curl openssl libnghttp2 ];

  installPhase = ''
    mkdir -p $out/share/polar-bookshelf $out/bin $out/lib
    mv opt/Polar\ Bookshelf/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib
    mv usr/share/* $out/share/
    ln -s $out/share/polar-bookshelf/polar-bookshelf $out/bin/polar-bookshelf
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
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
}
