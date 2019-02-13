{ stdenv, fetchFromGitHub, cmake, pkgconfig, git
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "wownero-${version}";

  version = "0.4.0.0";
  src = fetchFromGitHub {
    owner = "wownero";
    repo = "wownero";
    fetchSubmodules = true;
    rev    = "v${version}";
    sha256 = "1z5fpl4gwys4v8ffrymlzwrbnrbg73x553a9lxwny7ba8yg2k14p";
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc openssl unbound
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
