{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  binaryornot,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "test2ref";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nbiotcloud";
    repo = "test2ref";
    tag = "v${version}";
    hash = "sha256-Rgm7qZc1pFY/9gwzHjnI305Ch9enXzzWRsPZ7CQjzpQ=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    binaryornot
  ];

  pythonImportsCheck = [ "test2ref" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Testing Against Learned Reference Data";
    homepage = "https://github.com/nbiotcloud/test2ref";
    changelog = "https://github.com/nbiotcloud/test2ref/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
