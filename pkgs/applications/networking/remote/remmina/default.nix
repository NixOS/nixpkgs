{ stdenv, fetchurl, cmake, pkgconfig, makeWrapper
, glib, gtk, gettext, libxkbfile, libgnome_keyring, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem }:

let
  version = "1.1.2";

  desktopItem = makeDesktopItem {
    name = "remmina";
    desktopName = "Remmina";
    genericName = "Remmina Remote Desktop Client";
    exec = "remmina";
    icon = "remmina";
    comment = "Connect to remote desktops";
    categories = "GTK;GNOME;X-GNOME-NetworkSettings;Network;";
  };

in

stdenv.mkDerivation {
  name = "remmina-${version}";

  src = fetchurl {
    url = "https://github.com/FreeRDP/Remmina/archive/v${version}.tar.gz";
    sha256 = "214eb82e616f3158304f689692d467b45c537e295e6aed1c6d291b2d7d2e601e";
  };

  buildInputs = [ cmake pkgconfig makeWrapper
                  glib gtk gettext libxkbfile libgnome_keyring libX11
                  freerdp libssh libgcrypt gnutls ];

  cmakeFlags = "-DWITH_VTE=OFF -DWITH_TELEPATHY=OFF -DWITH_AVAHI=OFF";

  patches = [ ./lgthread.patch ];

  postInstall = ''
    mkdir -pv $out/share/applications
    mkdir -pv $out/share/icons
    cp ${desktopItem}/share/applications/* $out/share/applications
    cp -r $out/share/remmina/icons/* $out/share/icons
    wrapProgram $out/bin/remmina --prefix LD_LIBRARY_PATH : "${libX11}/lib"
  '';

  meta = with stdenv.lib; {
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://freerdp.github.io/Remmina/index.html";
    description = "Remote desktop client written in GTK+";
    maintainers = [ stdenv.lib.maintainers.ryantm ];
    platforms = platforms.linux;
  };
}
