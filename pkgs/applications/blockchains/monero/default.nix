{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, boost, miniupnpc, openssl, unbound
, zeromq, pcsclite, readline, libsodium, hidapi
, protobuf, randomx, rapidjson, libusb-compat-0_1
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.17.0.1";

  src = fetchFromGitHub {
    owner = "monero-project";
    repo = "monero";
    rev = "v${version}";
    sha256 = "1v0phvg5ralli4dr09a60nq032xqlci5d6v4zfq8304vgrn1ffgp";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    boost miniupnpc openssl unbound
    zeromq pcsclite readline
    libsodium hidapi randomx rapidjson
    protobuf libusb-compat-0_1
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
