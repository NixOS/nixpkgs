{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  cmake,
  doxygen,
  fetchpatch,
  fetchurl,
  glib,
  libxml2,
  pcre,
  zlib,
  libjpeg,
  giflib,
  libtiff,
  libpng,
  curl,
  freetype,
  boost,
  libGLU,
  libGL,
  libX11,
  libXinerama,
  libXrandr,
}:

stdenv.mkDerivation {
  pname = "openscenegraph";
  version = "2024-build";

  src = fetchFromGitLab {
    owner = "flightgear";
    repo = "openscenegraph";
    # release/2024-build as of 2025-08-08
    rev = "a4ea8ec535cc969e31e2026b13be147dcb978689";
    sha256 = "sha256-wnxm4G40j2e6Paqx0vfAR4s4L7esfCHcgxUJWNxk1SM=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    doxygen
  ];

  buildInputs =
    lib.optionals (!stdenv.hostPlatform.isDarwin) [
      libX11
      libXinerama
      libXrandr
      libGLU
      libGL
    ]
    ++ [
      glib
      libxml2
      pcre
      zlib
      libjpeg
      giflib
      libtiff
      libpng
      curl
      freetype
      boost
    ];

  patches = [
    (fetchpatch {
      name = "opencascade-api-patch";
      url = "https://github.com/openscenegraph/OpenSceneGraph/commit/bc2daf9b3239c42d7e51ecd7947d31a92a7dc82b.patch";
      hash = "sha256-VR8YKOV/YihB5eEGZOGaIfJNrig1EPS/PJmpKsK284c=";
    })
    # Fix compiling with libtiff when libtiff is compiled using CMake
    (fetchurl {
      url = "https://github.com/openscenegraph/OpenSceneGraph/commit/9da8d428f6666427c167b951b03edd21708e1f43.patch";
      hash = "sha256-YGG/DIHU1f6StbeerZoZrNDm348wYB3ydmVIIGTM7fU=";
    })
  ];

  cmakeFlags = [ "-DBUILD_OSG_APPLICATIONS=OFF" ];

  meta = with lib; {
    description = "3D graphics toolkit";
    homepage = "http://www.openscenegraph.org/";
    maintainers = with maintainers; [
      aanderse
      raskin
    ];
    platforms = with platforms; linux ++ darwin;
    license = "OpenSceneGraph Public License - free LGPL-based license";
  };
}
