{
  lib,
  stdenv,
  fetchurl,
  pkgConfigCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shapelib";
  version = "1.6.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://download.osgeo.org/shapelib/shapelib-${finalAttrs.version}.tar.gz";
    hash = "sha256-P/Xq0Yym0v4knw6As2HhrWeCFlEVJo7UpYx4CmDB4Os=";
  };

  doCheck = true;
  preCheck = ''
    patchShebangs tests contrib/tests
  '';

  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [ "shapelib" ];
  doInstallCheck = true;

  meta = {
    description = "C Library for reading, writing and updating ESRI Shapefiles";
    homepage = "http://shapelib.maptools.org/";
    license = with lib.licenses; [
      mit
      lgpl2Plus
    ];
    teams = [ lib.teams.geospatial ];
    changelog = "http://shapelib.maptools.org/release.html";
    pkgConfigModules = [ "shapelib" ];
  };
})
