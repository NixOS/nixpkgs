{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
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

  dependencies = with python3Packages; [
    opencv4
  ];

  pythonImportsCheck = [
    "camera"
  ];

  doCheck = false;

  meta = {
    description = "MeerK40t camera plugin";
    license = lib.licenses.mit;
    homepage = "https://github.com/meerk40t/meerk40t-camera";
    maintainers = with lib.maintainers; [ hexa ];
  };
}
