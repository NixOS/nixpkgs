{ stdenv, fetchFromGitHub, cmake, pkgconfig, git
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline
, IOKit ? null
}:

assert stdenv.isDarwin -> IOKit != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name    = "monero-${version}";
  version = "0.12.0.0";

  src = fetchFromGitHub {
    owner  = "monero-project";
    repo   = "monero";
    rev    = "v${version}";
    sha256 = "1lc9mkrl1m8mdbvj88y8y5rv44vinxf7dyv221ndmw5c5gs5zfgk";
  };

  nativeBuildInputs = [ cmake pkgconfig git ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq zeromq pcsclite readline
  ] ++ optional stdenv.isDarwin IOKit;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ];

  hardeningDisable = [ "fortify" ];

  meta = {
    description = "Private, secure, untraceable currency";
    homepage    = https://getmonero.org/;
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ ehmry rnhmjoj ];
  };
}
