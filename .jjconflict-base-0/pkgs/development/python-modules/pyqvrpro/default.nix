{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-vcr,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  requests,
  untangle,
}:

buildPythonPackage rec {
  pname = "pyqvrpro";
  version = "0.52";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oblogic7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lOd2AqnrkexNqT/usmJts5NW7vJtV8CRsliYgkhgRaU=";
  };

  propagatedBuildInputs = [
    pyyaml
    requests
    untangle
  ];

  nativeCheckInputs = [
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyqvrpro" ];

  meta = with lib; {
    description = "Module for interfacing with QVR Pro API";
    homepage = "https://github.com/oblogic7/pyqvrpro";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
