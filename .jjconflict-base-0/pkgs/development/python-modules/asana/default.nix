{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  pythonOlder,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "asana";
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "asana";
    repo = "python-asana";
    tag = "v${version}";
    hash = "sha256-TYZi/cjwAHuluHpunfStlfPg0SSyaKKWtkJhTun/hQ0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    six
    python-dateutil
    python-dotenv
    urllib3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "asana" ];

  disabledTestPaths = [
    # Tests require network access
    "build_tests/"
  ];

  meta = with lib; {
    description = "Python client library for Asana";
    homepage = "https://github.com/asana/python-asana";
    changelog = "https://github.com/Asana/python-asana/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
