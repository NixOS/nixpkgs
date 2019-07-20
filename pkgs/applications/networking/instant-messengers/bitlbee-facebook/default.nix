{ fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json-glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-facebook-${version}";
  version = "1.2.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "11068zhb1v55b1x0nhjc4f3p0glccxpcyk5c1630hfdzkj7vyqhn";
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
