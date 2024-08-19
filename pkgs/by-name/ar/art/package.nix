{ lib
, stdenv
, fetchFromBitbucket
, cmake
, pkg-config
, wrapGAppsHook3
, makeWrapper
, pixman
, libpthreadstubs
, gtkmm3
, libXau
, libXdmcp
, lcms2
, libiptcdata
, fftw
, expat
, pcre
, libsigcxx
, lensfun
, librsvg
, libcanberra-gtk3
, exiv2
, exiftool
, mimalloc
}:

stdenv.mkDerivation rec {
  pname = "art";
  version = "1.23";

  src = fetchFromBitbucket {
    owner = "agriggio";
    repo = "art";
    rev = version;
    hash = "sha256-OB/Rr4rHNJc40o6esNPDRbhN4EPGf2zhlzzM+mBpUUU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    pixman
    libpthreadstubs
    gtkmm3
    libXau
    libXdmcp
    lcms2
    libiptcdata
    fftw
    expat
    pcre
    libsigcxx
    lensfun
    librsvg
    exiv2
    exiftool
    libcanberra-gtk3
    mimalloc
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
  ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];
  env.CXXFLAGS = "-include cstdint"; # needed at least with gcc13 on aarch64-linux

  meta = {
    description = "A raw converter based on RawTherapee";
    homepage = "https://bitbucket.org/agriggio/art/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "art";
    platforms = lib.platforms.linux;
  };
}
