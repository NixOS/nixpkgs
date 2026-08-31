{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imath";
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "imath";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kmWj9g6PnvgEOojjiWYpJ9+lXwT1svpezYDsCns4NP0=";
  };

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  meta = {
    description = "C++ and python library of 2D and 3D vector, matrix, and math operations for computer graphics";
    homepage = "https://github.com/AcademySoftwareFoundation/Imath";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ paperdigits ];
    platforms = lib.platforms.all;
  };
})
