{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, doxygen
, graphviz
, libogg
}:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.4.1";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${pname}-${version}.tar.xz";
    # Official checksum is published at https://github.com/xiph/flac/releases/tag/${version}
    sha256 = "91303c3e5dfde52c3e94e75976c0ab3ee14ced278ab8f60033a3a12db9209ae6";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    doxygen
    graphviz
  ];

  buildInputs = [
    libogg
  ];

  cmakeFlags = lib.optionals (!stdenv.hostPlatform.isStatic) [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  CFLAGS = [ "-O3" "-funroll-loops" ];
  CXXFLAGS = [ "-O3" ];

  # doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with lib; {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ruuda ];
  };
}
