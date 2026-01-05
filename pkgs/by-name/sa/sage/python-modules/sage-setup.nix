{
  lib,
  buildPythonPackage,
  sage-src,
  cython,
  jinja2,
  pkgconfig, # the python module, not the pkg-config alias
}:

buildPythonPackage rec {
  version = src.version;
  format = "setuptools";
  pname = "sage-setup";
  src = sage-src;

  nativeBuildInputs = [ cython ];
  buildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ jinja2 ];

  preBuild = ''
    cd pkgs/sage-setup
  '';

  doCheck = false; # sagelib depends on sage-setup, but sage-setup's tests depend on sagelib

  meta = {
    description = "Build system of the Sage library";
    homepage = "https://www.sagemath.org";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
  };
}
