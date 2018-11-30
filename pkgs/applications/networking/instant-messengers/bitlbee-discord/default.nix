{ fetchFromGitHub, stdenv, bitlbee, autoreconfHook, pkgconfig, glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "bitlbee-discord-${version}";
  version = "0.4.1";

  src = fetchFromGitHub {
    rev = version;
    owner = "sm00th";
    repo = "bitlbee-discord";
    sha256 = "1n3xw5mcmg7224r09gbm39bd6h2158dwl6jx21290636b4345f4c";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ bitlbee glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Bitlbee plugin for Discord";

    homepage = https://github.com/sm00th/bitlbee-discord;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.lassulus ];
    platforms = stdenv.lib.platforms.linux;
  };
}
