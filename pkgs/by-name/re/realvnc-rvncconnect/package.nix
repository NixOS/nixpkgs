{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeDesktopItem,
  copyDesktopItems,
  autoPatchelfHook,
  makeWrapper,

  gtk3,
  pango,
  at-spi2-atk,
  cairo,
  gdk-pixbuf,
  glib,
  libepoxy,
  fontconfig,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "realvnc-rvncconnect";
  version = "8.1.0";

  src = fetchurl {
    url = "https://downloads.realvnc.com/download/file/realvnc-connect/RealVNC-Connect-${finalAttrs.version}-Linux-x64.deb";
    hash = "sha256-H/A8dNBKxXcnoneGbGP2HiLgi4TbEoX9Dkt232jtjNw=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    gtk3
    pango
    at-spi2-atk
    cairo
    gdk-pixbuf
    glib
    libepoxy
    fontconfig
    xorg.libXtst
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    cp -r usr/share/{icons,doc} $out/share

    phome=$out/lib/rvncconnect
    mkdir -p $phome
    cp -r usr/lib/rvncconnect/* $phome

    makeWrapper $phome/rvncconnect $out/bin/rvncconnect

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "com.realvnc.rvncconnect";
      desktopName = "RealVNC Connect";
      comment = "Connect to other computers running RealVNC Connect";
      exec = "rvncconnect";
      icon = "com.realvnc.rvncconnect";
      categories = [
        "Network"
        "RemoteAccess"
      ];
    })
    (makeDesktopItem {
      name = "com.realvnc.rvncconnect.connect.uri";
      desktopName = "RealVNC Connect URL Handler";
      exec = "rvncconnect -uri %u";
      mimeTypes = [ "x-scheme-handler/com.realvnc.vncviewer.connect" ];
      noDisplay = true;
    })
  ];

  meta = {
    description = "Remote desktop software by RealVNC";
    homepage = "https://www.realvnc.com/en/connect";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "rvncconnect";
  };
})
