{ lib
, python3Packages
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "legit";
  version = "1.2.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "0ngh3ar6v15516f52j21k6qz7hykmxfjadhb2rakvl27b5xvjy1c";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    clint
    crayons
    gitpython
    six
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/frostming/legit";
    description = "Git for Humans, Inspired by GitHub for Mac";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ryneeverett ];
  };
}
