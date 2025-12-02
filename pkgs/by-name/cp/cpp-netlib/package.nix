{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost186,
  openssl,
  llvmPackages_18,
}:
let
  # std::char_traits has been removed
  stdenvForCppNetlib = if stdenv.hostPlatform.isDarwin then llvmPackages_18.stdenv else stdenv;
in
stdenvForCppNetlib.mkDerivation rec {
  pname = "cpp-netlib";
  version = "0.13.0-final";

  src = fetchFromGitHub {
    owner = "cpp-netlib";
    repo = "cpp-netlib";
    tag = "cpp-netlib-${version}";
    sha256 = "18782sz7aggsl66b4mmi1i0ijwa76iww337fi9sygnplz2hs03a3";
    fetchSubmodules = true;
  };

  patches = [
    # 'u32_to_u8_iterator' was not declared
    ./0001-Compatibility-with-boost-1.83.patch
  ];

  # CMake 2.8 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    # io_service.hpp has been removed in boost 1.87+
    boost186
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
