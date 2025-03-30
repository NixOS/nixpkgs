{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  importlib-resources,
  jsonschema,
  packaging,
  pyyaml,
  referencing,
  typing-extensions,
  pytestCheckHook,
  versionCheckHook,
}:
buildPythonPackage rec {
  pname = "kubernetes-validate";
  version = "1.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "willthames";
    repo = "kubernetes-validate";
    tag = "v${version}";
    hash = "sha256-vxsftuipw0rHQIngxKlPHwBIW+rYAjfnEEaJDKmPyfQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    importlib-resources
    jsonschema
    packaging
    pyyaml
    referencing
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];

  pythonImportsCheck = [ "kubernetes_validate" ];

  meta = {
    description = "Module to validate Kubernetes resource definitions against the declared Kubernetes schemas";
    homepage = "https://github.com/willthames/kubernetes-validate";
    changelog = "https://github.com/willthames/kubernetes-validate/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "kubernetes-validate";
  };
}
