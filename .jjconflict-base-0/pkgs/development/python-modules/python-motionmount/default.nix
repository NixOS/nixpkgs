{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-motionmount";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vogelsproducts";
    repo = "python-MotionMount";
    tag = version;
    hash = "sha256-cXh+7DNbwYoKp76XmzPno6dcfujZT/QUO3Ns72M4gV0=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "motionmount" ];

  meta = {
    description = "Module to control the TVM7675 Pro (Signature) series of MotionMount";
    homepage = "https://github.com/vogelsproducts/python-MotionMount";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
