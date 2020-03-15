{ stdenv, fetchFromGitHub, cmake, boost, miniupnpc_2, openssl, unbound
, readline, libsodium, rapidjson
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "wownero";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "wownero";
    repo = "wownero";
    rev    = "v${version}";
    sha256 = "0lji24s6346qxcj4pmylv8byb8fnqzpmz81rx4i3zhc1bcsvdwas";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost miniupnpc_2 openssl unbound rapidjson readline libsodium
  ];

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = {
    description = ''
      A privacy-centric memecoin that was fairly launched on April 1, 2018 with
      no pre-mine, stealth-mine or ICO
    '';
    longDescription = ''
      Wownero has a maximum supply of around 184 million WOW with a slow and
      steady emission over 50 years. It is a fork of Monero, but with its own
      genesis block, so there is no degradation of privacy due to ring
      signatures using different participants for the same tx outputs on
      opposing forks.
    '';
    homepage    = https://wownero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ fuwa ];
  };
}
