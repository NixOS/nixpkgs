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
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "SFCGAL";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cx0QJCtAPR/WkWPpH+mZvq2803eDT7b+qlI5ma+CveE=";
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
