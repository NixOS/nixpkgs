<<<<<<< HEAD
{ lib, pythonPackages, fetchPypi }:

with pythonPackages;

buildPythonApplication rec {
=======
{ lib, pythonPackages }:

with pythonPackages;

let
  cerberus_1_1 = callPackage ./cerberus.nix { };
in buildPythonApplication rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "pyditz";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-2gNlrpBk4wxKJ1JvsNeoAv2lyGUc2mmQ0Xvn7eiaJVE=";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pyyaml six jinja2 cerberus ];
=======
    sha256 = "da0365ae9064e30c4a27526fb0d7a802fda5c8651cda6990d17be7ede89a2551";
  };
  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ pyyaml six jinja2 cerberus_1_1 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
<<<<<<< HEAD
    homepage = "https://pypi.org/project/pyditz/";
=======
    homepage = "https://pythonhosted.org/pyditz/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Drop-in replacement for the Ditz distributed issue tracker";
    maintainers = [ maintainers.ilikeavocadoes ];
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
