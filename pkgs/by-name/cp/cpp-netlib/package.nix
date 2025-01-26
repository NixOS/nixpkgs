{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "cpp-netlib";
  version = "0.13.0-final";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "18782sz7aggsl66b4mmi1i0ijwa76iww337fi9sygnplz2hs03a3";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    openssl
  ];

  cmakeFlags = [
    "-DCPP-NETLIB_BUILD_SHARED_LIBS=ON"
    # fatal error: 'boost/asio/stream_socket_service.hpp' file not found
    "-DCPP-NETLIB_BUILD_EXAMPLES=OFF"
    "-DCPP-NETLIB_BUILD_TESTS=OFF"
  ];

  # Most tests make network GET requests to various websites
  doCheck = false;

  meta = with lib; {
    description = "Collection of open-source libraries for high level network programming";
    homepage = "https://cpp-netlib.org";
    license = licenses.boost;
    platforms = platforms.all;
  };
}
