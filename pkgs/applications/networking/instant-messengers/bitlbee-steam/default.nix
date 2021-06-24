{ lib, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkg-config, glib, libgcrypt }:

with lib;
stdenv.mkDerivation rec {
  version = "1.4.2";
  pname = "bitlbee-steam";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "bitlbee";
    repo = "bitlbee-steam";
    sha256 = "121r92mgwv445wwxzh35n19fs5k81ihr0j19k256ia5502b1xxaq";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ bitlbee autoconf automake libtool libgcrypt ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Steam protocol plugin for BitlBee";

    homepage = "https://github.com/jgeboski/bitlbee-steam";
    license = licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
