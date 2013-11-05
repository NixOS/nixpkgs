{ stdenv, fetchurl, cmake, pkgconfig, makeWrapper
, glib, gtk, gettext, libxkbfile, libgnome_keyring, libX11
, freerdp, libssh, libgcrypt, gnutls }:

let version = "1.0.0"; in

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
    wrapProgram $out/bin/remmina --prefix LD_LIBRARY_PATH : "${libX11}/lib"
  '';

  meta = {
    license = "GPLv2";
    homepage = "http://remmina.sourceforge.net/";
    description = "Remmina is a remote desktop client written in GTK+";
    maintainers = [];
  };
}
