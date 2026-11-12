{
  cmake,
  fetchFromGitHub,
  freetype,
  lib,
  libjpeg,
  libtiff,
  libxml2,
  opencv,
  openexr,
  pkg-config,
  stdenv,
  swig,
  zlib,
  withPython ? true,
  python3,
}:

stdenv.mkDerivation {
  pname = "libyafaray";
  version = "3.5.1-unstable-2024-01-28";

  src = fetchFromGitHub {
    owner = "YafaRay";
    repo = "libYafaRay";
    rev = "8f4906ae88f8a527bbce37991a95e3e3857cb9ac";
    hash = "sha256-CBigthJWRTeZKbImJGJU/ytRzI+FWOvHLWhU8Qeraj8=";
  };

  # include/math/math.h:152:3: error: unrecognized instruction mnemonic
  postPatch = ''
    substituteInPlace include/math/math.h \
      --replace-fail "defined (__APPLE__)" "0"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    libjpeg
    libtiff
    libxml2
    opencv
    openexr
    swig
    zlib
  ]
  ++ lib.optional withPython python3;

  meta = {
    description = "Free, open source raytracer";
    downloadPage = "https://github.com/YafaRay/libYafaRay";
    homepage = "https://github.com/YafaRay/libYafaRay";
    maintainers = [ ];
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

# TODO: Add optional Ruby support
# TODO: Add Qt support? (CMake looks for it, but what for?)
