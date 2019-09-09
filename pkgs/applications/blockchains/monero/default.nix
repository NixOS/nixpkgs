{ stdenv, fetchgit
, cmake, pkgconfig, git
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium, hidapi
, python3Packages
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "monero";
  version = "0.14.1.0";

  src = fetchgit {
    url    = "https://github.com/monero-project/monero.git";
    rev    = "v${version}";
    sha256 = "1asa197fad81jfv12qgaa7y7pdr1r1pda96m9pvivkh4v30cx0nh";
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq zeromq pcsclite readline
    libsodium hidapi
    python3Packages.protobuf
  ] ++ optionals stdenv.isDarwin [ IOKit CoreData PCSC ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ] ++ optional stdenv.isDarwin "-DBoost_USE_MULTITHREADED=OFF";

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ehmry rnhmjoj ];
  };
}
