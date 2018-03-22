{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json-glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-facebook-${version}";
  version = "1.1.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "0kz2sc10iq01vn0hvf06bcdc1rsxz1j77z3mw55slf3j08xr07in";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ bitlbee glib json-glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = https://github.com/bitlbee/bitlbee-facebook;
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
