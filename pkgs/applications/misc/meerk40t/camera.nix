{
  lib,
  python3,
  fetchPypi,
}:

let
  inherit (python3.pkgs) buildPythonPackage;
in
buildPythonPackage rec {
  pname = "meerk40t-camera";
  version = "0.1.9";
  format = "setuptools";

  src = fetchPypi {
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
