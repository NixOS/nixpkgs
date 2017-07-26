{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json_glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-facebook-${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "jgeboski";
    repo = "bitlbee-facebook";
    sha256 = "08ibjqqcrmq1a5nmj8z93rjrdabi0yy2a70p31xalnfrh200m24c";
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
