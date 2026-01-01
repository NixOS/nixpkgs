{
  lib,
  stdenv,
  fetchurl,
<<<<<<< HEAD
  fetchDebianPatch,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation rec {
  pname = "shapelib";
  version = "1.6.2";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${version}.tar.gz";
    hash = "sha256-S3SjbO2U6ae+pAEVfmZK3cxb4lHn33+I1GdDYdoBLCE=";
  };

<<<<<<< HEAD
  patches = [
    # Fix build with gcc 15
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "1";
      patch = "gcc-15.patch";
      hash = "sha256-ubd8L2hxSAxTDiOSToVHGLHkpGOap5bnozdVdv9VgCQ=";
    })
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

<<<<<<< HEAD
  meta = {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = lib.licenses.gpl2;
    teams = [ lib.teams.geospatial ];
=======
  meta = with lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = licenses.gpl2;
    teams = [ teams.geospatial ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    changelog = "http://shapelib.maptools.org/release.html";
  };
}
