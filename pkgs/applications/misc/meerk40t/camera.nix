{ lib
, python3
<<<<<<< HEAD
, fetchPypi
}:

let
  inherit (python3.pkgs) buildPythonPackage;
=======
}:

let
  inherit (python3.pkgs) buildPythonPackage fetchPypi;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
buildPythonPackage rec {
  pname = "meerk40t-camera";
  version = "0.1.9";
  format = "setuptools";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3.pkgs.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-uGCBHdgWoorVX2XqMCg0YBweb00sQ9ZSbJe8rlGeovs=";
  };

  postPatch = ''
    sed -i '/meerk40t/d' setup.py
  '';

  propagatedBuildInputs = with python3.pkgs; [
    opencv4
  ];

  pythonImportsCheck = [
    "camera"
  ];

  doCheck = false;

  meta = with lib; {
    description = "MeerK40t camera plugin";
    license = licenses.mit;
    homepage = "https://github.com/meerk40t/meerk40t-camera";
    maintainers = with maintainers; [ hexa ];
  };
}
