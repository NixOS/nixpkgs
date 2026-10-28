{
  lib,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "kubexhunt";
  version = "2.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mr-xhunt";
    repo = "kubeXhunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MknzQhNLtuiW89TBYYU00xGgYZEbIKqMNk9I1SvzDzs=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    azure-identity
    boto3
    google-cloud-iam
    neo4j
    jinja2
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
    safety
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "kubexhunt" ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Kubernetes security assessment toolkit";
    homepage = "https://github.com/mr-xhunt/kubeXhunt";
    changelog = "https://github.com/mr-xhunt/kubeXhunt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "kubexhunt";
  };
})
