{ stdenv, fetchFromGitHub, cmake, pkgconfig, git
, boost, miniupnpc_2, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium, rapidjson
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "wownero-${version}";

  version = "0.6.0.0";
  src = fetchFromGitHub {
    owner = "wownero";
    repo = "wownero";
    rev    = "v${version}";
    sha256 = "1vy80cyz79mlr2msq6fx44rij0qp04bgxl6gzr6b1skiag4hnrqb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc_2 openssl unbound rapidjson
    cppzmq zeromq pcsclite readline libsodium
  ] ++ optionals stdenv.isDarwin [ IOKit CoreData PCSC ];

  cmakeFlags = [
    "-DReadline_ROOT_DIR=${readline.dev}"
    "-DMANUAL_SUBMODULES=ON"
  ] ++ optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  hardeningDisable = [ "fortify" ];

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
    platforms   = platforms.all;
    maintainers = with maintainers; [ fuwa ];
  };
}
