{ lib
, buildPythonPackage
, sage-src
, jupyter-sphinx
, sphinx
, sphinx-copybutton
}:

buildPythonPackage rec {
  version = src.version;
  pname = "sage-docbuild";
  src = sage-src;

  propagatedBuildInputs = [
    jupyter-sphinx
    sphinx
    sphinx-copybutton
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
