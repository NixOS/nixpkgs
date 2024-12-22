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

  meta = with lib; {
    description = "Build system of the Sage documentation";
    homepage = "https://www.sagemath.org";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
  };
}
