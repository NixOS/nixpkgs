{ fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib, json-glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-facebook";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "1qiiiq17ybylbhwgbwsvmshb517589r8yy5rsh1rfaylmlcxyy7z";
  };

  nativeBuildInputs = [ autoconf automake libtool pkgconfig ];

  buildInputs = [ bitlbee json-glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = "https://github.com/bitlbee/bitlbee-facebook";
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
