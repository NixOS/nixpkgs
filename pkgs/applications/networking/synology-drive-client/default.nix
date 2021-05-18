{
  stdenv
, xorg
, glib
, freetype
, libxkbcommon
, fontconfig
, pango
, gtk3
, gtk2-x11
, gcc-unwrapped
, dbus_libs
, qt5
, autoPatchelfHook
, dpkg
, fetchurl
, lib
}:

stdenv.mkDerivation {
  pname = "synology-drive-client";
  
  version = "2.0.4";

  srcs = [
    (fetchurl {
      url = "http://archive.ubuntu.com/ubuntu/pool/universe/q/qtlocation-opensource-src/libqt5positioning5_5.15.2+dfsg-2_amd64.deb";
      sha256 = "01f9qgqkd6m3idr5f0w2k5cl9sjk7617fzp023d0qfnsw661wy56";
    })
    (fetchurl {
      url = "https://global.download.synology.com/download/Utility/SynologyDriveClient/2.0.4-11112/Ubuntu/Installer/x86_64/synology-drive-client-11112.x86_64.deb";
      sha256 = "0q9zyf98zw75j0yfwidqmc7jwf2zhg942xsqvkxxdqlrncmb4g01";
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    xorg.libX11
    glib
    freetype
    libxkbcommon
    xorg.libICE
    xorg.libXrender
    xorg.libSM
    fontconfig
    pango
    gtk3
    gtk2-x11
    gcc-unwrapped
    dbus_libs
    qt5.qtbase
    qt5.qtx11extras
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    for _src in $srcs; do
      dpkg -x $_src $out
    done
    rm -rf $out/usr/lib/nautilus
    rm -rf $out/opt/Synology/SynologyDrive/package/cloudstation/icon-overlay
    cp -r $out/usr/bin $out/bin
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Desktop application to synchronize files and folders between the computer and the Synology Drive server to access, browse, and share files via file browser";
    homepage = "https://www.synology.com/en-global/dsm/feature/drive";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
