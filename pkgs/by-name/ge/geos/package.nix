{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  testers,

  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "geos";
  version = "3.14.1";

  src = fetchFromGitHub {
    owner = "libgeos";
    repo = "geos";
    tag = finalAttrs.version;
    hash = "sha256-lOf14Qva/bbbiywbSE7GbkDQftjY0RudTOaqjllnsj4=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/libgeos/geos/issues/930
  cmakeFlags = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;unit-geom-Envelope"
  ];

  doCheck = true;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    geos = callPackage ./tests.nix { geos = finalAttrs.finalPackage; };
  };

<<<<<<< HEAD
  meta = {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = lib.licenses.lgpl21Only;
    mainProgram = "geosop";
    teams = [ lib.teams.geospatial ];
=======
  meta = with lib; {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = licenses.lgpl21Only;
    mainProgram = "geosop";
    teams = [ teams.geospatial ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pkgConfigModules = [ "geos" ];
    changelog = "https://github.com/libgeos/geos/releases/tag/${finalAttrs.finalPackage.version}";
  };
})
