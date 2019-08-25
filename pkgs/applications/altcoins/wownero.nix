{ stdenv, fetchFromGitHub, cmake, pkgconfig, git
, boost, miniupnpc_2, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium, rapidjson
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "wownero-${version}";

  version = "0.6.1.2";
  src = fetchFromGitHub {
    owner = "wownero";
    repo = "wownero";
    rev    = "v${version}";
    sha256 = "03q3pviyhrldpa3f4ly4d97jr39hvrz37chl102bap0790d9lk09";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc_2 openssl unbound rapidjson
    cppzmq zeromq pcsclite readline libsodium
  ];

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ];

  meta = {
    description = "Wownero is a fork of the cryptocurrency Monero with primary alterations";
    longDescription = ''
      Wownero’s emission is capped and supply is finite. Wownero is a fairly
      launched coin with no premine. It’s not a fork of another blockchain. With
      its own genesis block there is no degradation of privacy caused by ring
      signatures using different participants for the same transaction outputs.
      Unlike opposing forks.
    '';
    homepage    = http://wownero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ fuwa ];
  };
}
