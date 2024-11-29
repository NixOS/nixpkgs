{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  dictdiffer,
  grpcio,
  protobuf,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pygnmi";
  version = "0.8.14";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "akarneliuk";
    repo = "pygnmi";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ncp/OwELy/QOvGhLUZW2qTQZsckWI4CGrlEAZ20RtQI=";
  };

  propagatedBuildInputs = [
    cryptography
    dictdiffer
    grpcio
    protobuf
  ];

  # almost all tests fail with:
  # TypeError: expected string or bytes-like object
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygnmi" ];

  meta = with lib; {
    description = "Pure Python gNMI client to manage network functions and collect telemetry";
    mainProgram = "pygnmicli";
    homepage = "https://github.com/akarneliuk/pygnmi";
    changelog = "https://github.com/akarneliuk/pygnmi/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
