{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  openssl,
  asio,
  tinyxml-2,
  openjdk11,
  python3,
  foonathan-memory,
  fastcdr,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastdds";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "eProsima";
    repo = "Fast-DDS";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Qyn3Y1h7egCWxlAIfXae0U7BwMY/qLayjV7QDNhOvJk=";
  };

  patches = [
    ./patches/add-cstdint-include.patch
  ];

  nativeBuildInputs = [
    cmake
    openjdk11
    pkg-config
  ];

  buildInputs = [
    openssl
    asio
    tinyxml-2
    foonathan-memory
    fastcdr
    python3
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
    "-DSECURITY=ON"
    "-DCOMPILE_EXAMPLES=OFF"
    "-DCMAKE_PREFIX_PATH=${foonathan-memory}"
  ];

  meta = {
    description = "Fast RTPS (DDS) is a C++ implementation of the RTPS (Real Time Publish Subscribe) protocol";
    homepage = "https://github.com/eProsima/Fast-DDS";
    license = lib.licenses.asl20;
    longDescription = ''
      eProsima Fast RTPS is a C++ implementation of the RTPS (Real Time Publish Subscribe) protocol,
      which provides publisher-subscriber communication over unreliable transports such as UDP,
      as defined and maintained by the Object Management Group (OMG) consortium.
    '';
    platforms = lib.platforms.linux;
  };
})
