{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, git, doxygen, graphviz
, boost, miniupnpc, openssl, unbound, cppzmq
, pcsclite, readline, libsodium
}:

let
  version = "0.14.2.2";
in
stdenv.mkDerivation {
  pname = "aeon";
  inherit version;

  src = fetchFromGitHub {
    owner = "aeonix";
    repo = "aeon";
    rev = "v${version}-aeon";
    fetchSubmodules = true;
    sha256 = "sha256-2MptLS12CUm9eUKm+V+yYpbLVwNyZeZ5HvAFyjEc4R4=";
  };

  nativeBuildInputs = [ cmake pkg-config git doxygen graphviz ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq pcsclite readline libsodium
  ];

  cmakeFlags = [
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ];

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "Private, secure, untraceable currency";
    homepage = "http://www.aeon.cash/";
    license = licenses.bsd3;
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
