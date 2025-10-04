{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "shapelib";
  version = "1.6.2";

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${version}.tar.gz";
    hash = "sha256-S3SjbO2U6ae+pAEVfmZK3cxb4lHn33+I1GdDYdoBLCE=";
  };

  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

  meta = with lib; {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = licenses.gpl2;
    teams = [ teams.geospatial ];
    changelog = "http://shapelib.maptools.org/release.html";
  };
}
