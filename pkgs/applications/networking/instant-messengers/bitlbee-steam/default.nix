{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, libgcrypt }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-steam-2015-09-10";

  src = fetchFromGitHub {
    rev = "011375b2d3c67c15d51ca203de0ecaab3b4b7587";
    owner = "jgeboski";
    repo = "bitlbee-steam";
    sha256 = "1m91x3208z9zxppz998i6060alcalfly9ix9jxismj45xyp6mdx7";
  };

  buildInputs = [ bitlbee autoconf automake libtool pkgconfig glib libgcrypt ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Steam protocol plugin for BitlBee";

    homepage = https://github.com/jgeboski/bitlbee-steam;
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
