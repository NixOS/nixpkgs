{
  lib,
  buildPythonPackage,
  sage-src,
  furo,
  jupyter-sphinx,
  sphinx,
  sphinx-copybutton,
  sphinx-inline-tabs,
}:

buildPythonPackage rec {
  version = src.version;
  format = "setuptools";
  pname = "sage-docbuild";
  src = sage-src;

  propagatedBuildInputs = [
    furo
    jupyter-sphinx
    sphinx
    sphinx-copybutton
    sphinx-inline-tabs
  ];

  preBuild = ''
    cd pkgs/sage-docbuild
  '';

  doCheck = false; # we will run tests in sagedoc.nix

  meta = {
    description = "Build system of the Sage documentation";
    homepage = "https://www.sagemath.org";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.sage ];
  };
}
