{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  cgal,
  boost,
  eigen,
  mpfr,
  nlohmann_json,
  gmp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfcgal";
  version = "2.3.0";

  src = fetchFromGitLab {
    owner = "sfcgal";
    repo = "SFCGAL";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VwbcAdSORUUbkYoH5H1wkKMOqBlUMltMVYEoNtPH0p4=";
  };

  buildInputs = [
    cgal
    boost
    eigen
    mpfr
    nlohmann_json
    gmp
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "SFCGAL_WITH_EIGEN" true)
  ];

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
