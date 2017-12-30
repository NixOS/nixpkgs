{ fetchurl, fetchFromGitHub, stdenv, bitlbee, autoconf, automake, libtool, pkgconfig, glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-discord-2017-12-27";

  src = fetchFromGitHub {
    rev = "6a03db169ad44fee55609ecd16e19f3c0f99a182";
    owner = "sm00th";
    repo = "bitlbee-discord";
    sha256 = "1ci9a12c6zg8d6i9f95pq6dal79cp4klmmsyj8ag2gin90kl3x95";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ bitlbee autoconf automake libtool glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Bitlbee plugin for Discord";

    homepage = https://github.com/sm00th/bitlbee-discord;
    license = licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
