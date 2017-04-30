{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json_glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-facebook-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "jgeboski";
    repo = "bitlbee-facebook";
    sha256 = "0qclyc2zz8144dc42bhfv2xxrahpiv9j2iwq9h3cmfxszvkb8r3s";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ bitlbee glib json_glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = https://github.com/jgeboski/bitlbee-facebook;
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
