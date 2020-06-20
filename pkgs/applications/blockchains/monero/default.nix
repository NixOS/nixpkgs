{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, boost, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, pythonProtobuf, randomx, rapidjson, libusb-compat-0_1
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.16.0.0";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    sha256 = "0x74h5z0nxxxip97ibc854pqmrgd8r4d6w62m424f66i8gbzfskh";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    pythonProtobuf libusb-compat-0_1
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit CoreData PCSC ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_DEVICE_TREZOR=ON"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ] ++ stdenv.lib.optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage    = "https://getmonero.org/";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ehmry rnhmjoj ];
  };
}
