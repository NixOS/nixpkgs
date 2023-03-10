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
    sha256 = "sha256-4yLVih9I0j2d049DJnKGX2955zpvnMWl9X/KqD61qOQ=";
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
    changelog = "https://xiph.org/flac/changelog.html";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ruuda ];
  };
}
