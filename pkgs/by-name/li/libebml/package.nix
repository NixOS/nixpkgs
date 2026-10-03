{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  utf8cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libebml";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libebml";
    rev = "release-${finalAttrs.version}";
    sha256 = "sha256-myXqGGFfL+CuaOwwNuSZC4+fgqcQNRzhWN0jrY3k5r8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    utf8cpp
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = lib.licenses.lgpl21;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
