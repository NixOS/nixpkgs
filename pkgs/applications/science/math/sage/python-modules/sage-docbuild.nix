{ lib
, buildPythonPackage
, sage-src
<<<<<<< HEAD
, jupyter-sphinx
, sphinx
, sphinx-copybutton
=======
, sphinx
, jupyter-sphinx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  version = src.version;
  pname = "sage-docbuild";
  src = sage-src;

  propagatedBuildInputs = [
<<<<<<< HEAD
    jupyter-sphinx
    sphinx
    sphinx-copybutton
=======
    sphinx
    jupyter-sphinx
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
