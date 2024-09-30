{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  cgal,
  boost,
  mpfr,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfcgal";
  version = "1.5.2";

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "SFCGAL";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fK1PfLm6n05PhH/sT6N/hQtH5Z6+Xc1nUCS1NYpLDcY=";
  };

  buildInputs = [
    cgal
    boost
    mpfr
    gmp
  ];

  nativeBuildInputs = [ cmake ];

  patches = [ ./cmake-fix.patch ];

  meta = {
    description = "C++ wrapper library around CGAL with the aim of supporting ISO 191007:2013 and OGC Simple Features for 3D operations";
    homepage = "https://sfcgal.gitlab.io/SFCGAL/";
    changelog = "https://gitlab.com/sfcgal/SFCGAL/-/releases/v${finalAttrs.version}";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.fqidz ];
  };
})
