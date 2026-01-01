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
<<<<<<< HEAD
  fftwSinglePrec,
=======
  fftw,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

stdenv.mkDerivation rec {
  pname = "art";
<<<<<<< HEAD
  version = "1.25.12";
=======
  version = "1.25.11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "artpixls";
    repo = "ART";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-iF409zromKDliFRjGWYHBeK38UsxUCH70dgSsHLHhhw=";
=======
    hash = "sha256-viX2GjPV4ZvaK7u6KgANbbMLCFRLbCwd48NiIcsHqSY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    fftwSinglePrec
=======
    fftw
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    homepage = "https://artraweditor.github.io";
=======
    homepage = "https://art.pixls.us";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "ART";
    platforms = lib.platforms.linux;
  };
}
