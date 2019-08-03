{ stdenv, fetchFromGitHub, libotr, automake, autoconf, libtool, glib, pkgconfig, irssi }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "irssi-otr-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "cryptodotis";
    repo = "irssi-otr";
    rev = "v${version}";
    sha256 = "0c5wb2lg9q0i1jdhpyb5vpvxaa2xx00gvp3gdk93ix9v68gq1ppp";
  };

  preConfigure = "sh ./bootstrap";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libotr automake autoconf libtool glib irssi ];

  NIX_CFLAGS_COMPILE="-I ${irssi}/include/irssi -I ${irssi}/include/irssi/src/core -I ${irssi}/include/irssi/src/";

  meta = {
    homepage = https://github.com/cryptodotis/irssi-otr;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
