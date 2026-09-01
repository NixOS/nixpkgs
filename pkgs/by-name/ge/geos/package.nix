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
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "libgeos";
    repo = "geos";
    tag = finalAttrs.version;
    hash = "sha256-vclG3r6DHH54SordAKpGYFnyC/WL55p8QiUcGunyXMo=";
  };

  nativeBuildInputs = [ cmake ];

  strictDeps = true;

  doCheck = true;

  passthru.tests = {
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    geos = callPackage ./tests.nix { geos = finalAttrs.finalPackage; };
  };

  __structuredAttrs = true;

  meta = {
    description = "C/C++ library for computational geometry with a focus on algorithms used in geographic information systems (GIS) software";
    homepage = "https://libgeos.org";
    license = lib.licenses.lgpl21Only;
    mainProgram = "geosop";
    teams = [ lib.teams.geospatial ];
    pkgConfigModules = [ "geos" ];
    changelog = "https://github.com/libgeos/geos/releases/tag/${finalAttrs.finalPackage.version}";
  };
})
