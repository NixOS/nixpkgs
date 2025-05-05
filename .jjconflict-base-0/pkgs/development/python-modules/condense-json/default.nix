{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "condense-json";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "condense-json";
    tag = version;
    hash = "sha256-eZ8d8N7k8VL7dFkORHmp7JmHM1/11Km8BCriWw/LiwE=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "condense_json" ];

  meta = {
    description = "Python function for condensing JSON using replacement strings";
    homepage = "https://github.com/simonw/condense-json";
    changelog = "https://github.com/simonw/condense-json/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
