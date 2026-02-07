{
  lib,
  stdenv,
  fetchurl,
  fetchDebianPatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shapelib";
  version = "1.6.2";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${finalAttrs.version}.tar.gz";
    hash = "sha256-S3SjbO2U6ae+pAEVfmZK3cxb4lHn33+I1GdDYdoBLCE=";
  };

  patches = [
    # Fix build with gcc 15
    (fetchDebianPatch {
      inherit (finalAttrs) pname version;
      debianRevision = "1";
      patch = "gcc-15.patch";
      hash = "sha256-ubd8L2hxSAxTDiOSToVHGLHkpGOap5bnozdVdv9VgCQ=";
    })
  ];

  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

  meta = {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = lib.licenses.gpl2;
    teams = [ lib.teams.geospatial ];
    changelog = "http://shapelib.maptools.org/release.html";
  };
})
