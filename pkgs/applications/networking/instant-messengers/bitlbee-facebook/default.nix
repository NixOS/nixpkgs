{ lib, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkg-config, glib, json-glib }:

with lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-facebook";
  version = "1.2.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-facebook";
    sha256 = "sha256-/3jfGa3UK5cD1Ll4j3JC5YSyoK5b8/U4XNQvfwKOMeI=";
  };

  nativeBuildInputs = [ autoconf automake libtool pkg-config ];

  buildInputs = [ bitlbee json-glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "The Facebook protocol plugin for bitlbee";

    homepage = "https://github.com/bitlbee/bitlbee-facebook";
    license = licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
