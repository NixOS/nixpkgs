{
  lib,
  fetchFromGitHub,
  stdenv,
  bitlbee,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "bitlbee-discord";
  version = "0.4.3";

  src = fetchFromGitHub {
    rev = version;
    owner = "sm00th";
    repo = "bitlbee-discord";
    sha256 = "00qgdvrp7hv02n0ns685igp810zxmv3adsama8601122al6x041n";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ bitlbee ];

  preConfigure = ''
    export BITLBEE_PLUGINDIR=$out/lib/bitlbee
    export BITLBEE_DATADIR=$out/share/bitlbee
    ./autogen.sh
  '';

  meta = with lib; {
    description = "Bitlbee plugin for Discord";

    homepage = "https://github.com/sm00th/bitlbee-discord";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lassulus ];
    platforms = lib.platforms.linux;
  };
}
