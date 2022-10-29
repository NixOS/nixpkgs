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
  version = "1.4.2";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${pname}-${version}.tar.xz";
    # Official checksum is published at https://github.com/xiph/flac/releases/tag/${version}
    sha256 = "e322d58a1f48d23d9dd38f432672865f6f79e73a6f9cc5a5f57fcaa83eb5a8e4";
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
