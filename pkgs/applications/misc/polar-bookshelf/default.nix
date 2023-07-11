{ stdenv
, lib
, makeWrapper
, fetchurl
, dpkg
, wrapGAppsHook
, autoPatchelfHook
, gtk3
, cairo
, pango
, atk
, gdk-pixbuf
, glib
, at-spi2-atk
, dbus
, libX11
, libxcb
, libXi
, libXcursor
, libXdamage
, libXrandr
, libXcomposite
, libXext
, libXfixes
, libXrender
, libXtst
, libXScrnSaver
, nss
, nspr
, alsa-lib
, cups
, fontconfig
, expat
, libudev0-shim
, glibc
, curl
, openssl
, libnghttp2
, gsettings-desktop-schemas
, libdrm
, mesa
}:


stdenv.mkDerivation rec {
  pname = "polar-bookshelf";
  version = "2.0.103";

  # fetching a .deb because there's no easy way to package this Electron app
  src = fetchurl {
    url = "https://github.com/burtonator/polar-bookshelf/releases/download/v${version}/polar-desktop-app-${version}-amd64.deb";
    hash = "sha256-jcq0hW698bAhVM3fLQQeKAnld33XLkHsGjS3QwUpciQ=";
  };

  buildInputs = [
    libdrm
    mesa
    gsettings-desktop-schemas
    glib
    gtk3
    cairo
    pango
    atk
    gdk-pixbuf
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
    alsa-lib
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
    runHook preInstall

    mkdir -p $out/share/polar-bookshelf
    mkdir -p $out/bin
    mkdir -p $out/lib

    mv opt/Polar/* $out/share/polar-bookshelf
    mv $out/share/polar-bookshelf/*.so $out/lib

    mv usr/share/* $out/share/

    ln -s $out/share/polar-bookshelf/polar-desktop-app $out/bin/polar-desktop-app

    substituteInPlace $out/share/applications/polar-desktop-app.desktop \
      --replace "/opt/Polar/polar-desktop-app" "$out/bin/polar-desktop-app"

    runHook postInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  meta = {
    homepage = "https://getpolarized.io/";
    description = "Personal knowledge repository for PDF and web content supporting incremental reading and document annotation";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.noneucat ];
  };

}
