{ stdenv, fetchFromGitHub, cmake, pkgconfig, git, doxygen, graphviz
, boost, miniupnpc, openssl, unbound, cppzmq
, zeromq, pcsclite, readline, libsodium
}:

let
  version = "0.13.0.0";
in
stdenv.mkDerivation {
  pname = "aeon";
  inherit version;

  src = fetchFromGitHub {
    owner = "aeonix";
    repo = "aeon";
    rev = "v${version}-aeon";
    fetchSubmodules = true;
    sha256 = "07d87n1j4dc9gfwj6xy5jdpryn45095xdh961g6xjnjzc5fivjch";
  };

  nativeBuildInputs = [ cmake pkgconfig git doxygen graphviz ];

  buildInputs = [
    boost miniupnpc openssl unbound
    cppzmq zeromq pcsclite readline libsodium
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_GUI_DEPS=ON"
    "-DReadline_ROOT_DIR=${readline.dev}"
  ];

  hardeningDisable = [ "fortify" ];

  meta = with stdenv.lib; {
    description = "Private, secure, untraceable currency";
    homepage = http://www.aeon.cash/;
    license = licenses.bsd3;
    maintainers = [ maintainers.aij ];
    platforms = [ "x86_64-linux" ];
  };
}
