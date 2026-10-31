{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "azurefox";
  version = "1.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "TacoRocket";
    repo = "AzureFox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uyw5+tD/+jucgKKihBeVP0AJY7hUf0Sk2776rbTTrRE=";
  };

  pythonRelaxDeps = true;

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    azure-identity
    azure-keyvault-secrets
    azure-mgmt-apimanagement
    azure-mgmt-authorization
    azure-mgmt-automation
    azure-mgmt-compute
    azure-mgmt-containerregistry
    azure-mgmt-containerservice
    azure-mgmt-keyvault
    azure-mgmt-mysqlflexibleservers
    azure-mgmt-network
    azure-mgmt-postgresqlflexibleservers
    azure-mgmt-resource
    azure-mgmt-resource-deployments
    azure-mgmt-resource-subscriptions
    azure-mgmt-sql
    azure-mgmt-storage
    azure-mgmt-web
    certifi
    pydantic
    pyyaml
    rich
    six
    typer
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "azurefox" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Azure situational awareness and management-plane reconnaissance tool";
    homepage = "https://github.com/TacoRocket/AzureFox";
    changelog = "https://github.com/TacoRocket/AzureFox/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "azurefox";
  };
})
