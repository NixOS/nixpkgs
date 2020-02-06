{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium, hidapi
, python3Packages, randomx, rapidjson
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.15.0.1";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    sha256 = "0sypa235lf2bbib4b71xpaw39h9304slgsvnsz8wmy9fq1zx009m";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    python3Packages.protobuf
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit CoreData PCSC ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ] ++ stdenv.lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ehmry rnhmjoj ];
  };
}
