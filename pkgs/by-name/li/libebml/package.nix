{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libebml";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "Matroska-Org";
    repo = "libebml";
    rev = "release-${version}";
    sha256 = "sha256-PIVBePTWceMgiENdaL9lvXIL/RQIrtg7l0OG2tO0SU8=";
  };

  patches = [
    (fetchpatch {
      name = "libebml-fix-cmake-4.patch";
      url = "https://github.com/Matroska-Org/libebml/commit/6725c5f0169981cb0bd2ee124fbf0d8ca30b762d.patch";
      hash = "sha256-q62EWnJmQzBtra1xL0N7rC4RARJZQ/HAVyorzvB7XFY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=YES"
    "-DCMAKE_INSTALL_PREFIX="
  ];

  meta = with lib; {
    description = "Extensible Binary Meta Language library";
    homepage = "https://dl.matroska.org/downloads/libebml/";
    license = licenses.lgpl21;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
