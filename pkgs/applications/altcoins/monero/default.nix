{ stdenv, fetchgit
, cmake, pkgconfig, git
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium, hidapi
, CoreData, IOKit, PCSC
}:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "monero-${version}";
  version = "0.13.0.4";

  src = fetchgit {
    url    = "https://github.com/monero-project/monero.git";
    rev    = "v${version}";
    sha256 = "1ambgakapijhsi1pd70vw8vvnlwa3nid944lqkbfq3wl25lmc70d";
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq zeromq pcsclite readline
    libsodium hidapi
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
