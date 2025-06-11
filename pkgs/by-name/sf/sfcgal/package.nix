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
  version = "2.1.0";

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "SFCGAL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-m8oyfL3rF4qLugoEFa8iiqS5D1Oljg+x1qMp9KfiQ5c=";
  };

  buildInputs = [
    cgal
    boost
    mpfr
    gmp
  ];

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C++ wrapper library around CGAL with the aim of supporting ISO 191007:2013 and OGC Simple Features for 3D operations";
    homepage = "https://sfcgal.gitlab.io/SFCGAL/";
    changelog = "https://gitlab.com/sfcgal/SFCGAL/-/releases/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fqidz ];
    teams = [ lib.teams.geospatial ];
  };
})
