{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  lerc,
  libxkbcommon,
  libepoxy,
  libXtst,
  wrapGAppsHook3,
  pixman,
  libpthreadstubs,
  gtkmm3,
  libXau,
  libXdmcp,
  lcms2,
  libraw,
  libiptcdata,
  fftwSinglePrec,
  expat,
  pcre2,
  libsigcxx,
  lensfun,
  librsvg,
  libcanberra-gtk3,
  exiv2,
  exiftool,
  mimalloc,
  openexr,
  ilmbase,
  opencolorio,
  color-transformation-language,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "art";
  version = "1.26.1";

  src = fetchFromGitHub {
    owner = "artpixls";
    repo = "ART";
    tag = finalAttrs.version;
    hash = "sha256-Abh3Hj3wKdWNN7rdU61MgkZHmoa7ufYzZGKsrxplkj0=";
  };

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.9)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    lerc
    libxkbcommon
    libepoxy
    libXtst
    pixman
    libpthreadstubs
    gtkmm3
    libXau
    libXdmcp
    lcms2
    libraw
    libiptcdata
    fftwSinglePrec
    expat
    pcre2
    libsigcxx
    lensfun
    librsvg
    exiv2
    exiftool
    libcanberra-gtk3
    mimalloc
    openexr
    ilmbase
    opencolorio
    color-transformation-language
  ];

  cmakeFlags = [
    "-DPROC_TARGET_NUMBER=2"
    "-DCACHE_NAME_SUFFIX=\"\""
    "-DENABLE_OCIO=True"
    "-DENABLE_CTL=1"
    "-DCTL_INCLUDE_DIR=${color-transformation-language}/include/CTL"
  ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];
  env.CXXFLAGS = "-include cstdint"; # needed at least with gcc13 on aarch64-linux

  meta = {
    description = "Raw converter based on RawTherapee";
    homepage = "https://artraweditor.github.io";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "ART";
    platforms = lib.platforms.linux;
  };
})
