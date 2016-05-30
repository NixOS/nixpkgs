{ stdenv, fetchurl, cmake, pkgconfig, makeWrapper
, glib, gtk, gettext, libxkbfile, libgnome_keyring, libX11
, freerdp, libssh, libgcrypt, gnutls, makeDesktopItem }:

let
  version = "1.0.0";
  
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
    url = "https://github.com/downloads/FreeRDP/Remmina/Remmina-${version}.tar.gz";
    sha256 = "7cd0d2d6adbd96c7139da8c4bfc4cf4821e1fa97242bb9cc9db32a53df289731";
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
    wrapProgram $out/bin/remmina --prefix LD_LIBRARY_PATH : "${libX11.out}/lib"
  '';

  meta = with stdenv.lib; {
    license = stdenv.lib.licenses.gpl2;
    homepage = "http://remmina.sourceforge.net/";
    description = "Remote desktop client written in GTK+";
    maintainers = [];
    platforms = platforms.linux;
  };
}
