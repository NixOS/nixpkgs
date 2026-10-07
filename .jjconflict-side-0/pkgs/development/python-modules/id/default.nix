{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pretend,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "id";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "di";
    repo = "id";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qO9zUjJ2ATpulFANJw7XJexIs71XXMuEB8C0acoDnxI=";
  };

  build-system = [ flit-core ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [ "id" ];

  meta = {
    description = "Tool for generating OIDC identities";
    homepage = "https://github.com/di/id";
    changelog = "https://github.com/di/id/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
