{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "uchardet";
  version = "0.0.8";

  outputs = [
    "bin"
    "out"
    "man"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "sha256-6Xpgz8AKHBR6Z0sJe7FCKr2fp4otnOPz/cwueKNKxfA=";
  };

  patches = [
    # Fix the build with CMake 4.
    (fetchpatch {
      name = "uchardet-cmake-4.patch";
      url = "https://gitlab.freedesktop.org/uchardet/uchardet/-/commit/6e163c978a7c13a6d3ff64a1e3dd4ba81d2d9e09.patch";
      hash = "sha256-WXIQEoIpT7b5vELAfQJFEt2hiYrlnGCjV7ILCmd9kqY=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  doCheck = !stdenv.hostPlatform.isi686; # tests fail on i686

  meta = with lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    mainProgram = "uchardet";
    homepage = "https://www.freedesktop.org/wiki/Software/uchardet/";
    license = licenses.mpl11;
    maintainers = [ ];
    platforms = with platforms; unix;
  };
}
