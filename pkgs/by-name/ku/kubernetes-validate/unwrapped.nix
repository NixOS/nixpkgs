{
  lib,
  buildPythonPackage,
  fetchPypi,
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
buildPythonPackage (finalAttrs: {
  pname = "kubernetes-validate";
  version = "1.36.0";
  pyproject = true;

  src = fetchPypi {
    pname = "kubernetes_validate";
    inherit (finalAttrs) version;
    hash = "sha256-7b/S256ItXECmqFqsRFsZQKtK5YotnON051jkyP4RxU=";
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
    versionCheckHook
  ];

  pythonImportsCheck = [ "kubernetes_validate" ];

  meta = {
    description = "Module to validate Kubernetes resource definitions against the declared Kubernetes schemas";
    homepage = "https://github.com/willthames/kubernetes-validate";
    changelog = "https://github.com/willthames/kubernetes-validate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lykos153 ];
    mainProgram = "kubernetes-validate";
  };
})
