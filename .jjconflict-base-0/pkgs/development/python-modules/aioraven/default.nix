{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  iso4217,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "aioraven";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cottsay";
    repo = "aioraven";
    tag = version;
    hash = "sha256-rGqaDJtpdDWd8fxdfwU+rmgwEzZyYHfbiZxUlWoH2ks=";
  };

  build-system = [ setuptools ];

  dependencies = [
    iso4217
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioraven" ];

  meta = with lib; {
    description = "Module for communication with RAVEn devices";
    homepage = "https://github.com/cottsay/aioraven";
    changelog = "https://github.com/cottsay/aioraven/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
