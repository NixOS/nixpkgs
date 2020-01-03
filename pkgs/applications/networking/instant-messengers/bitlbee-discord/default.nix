{ fetchFromGitHub, stdenv, bitlbee, autoreconfHook, pkgconfig, glib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  pname = "bitlbee-discord";
  version = "0.4.2";

  src = fetchFromGitHub {
    rev = version;
    owner = "sm00th";
    repo = "bitlbee-discord";
    sha256 = "02pigk2vbz0jdz11f96sygdvp1j762yjn62h124fkcsc070g7a2f";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ bitlbee glib ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    export BITLBEE_DATADIR=$out/share/bitlbee
    ./autogen.sh
  '';

  meta = {
    description = "Bitlbee plugin for Discord";

    homepage = https://github.com/sm00th/bitlbee-discord;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lassulus jb55 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
