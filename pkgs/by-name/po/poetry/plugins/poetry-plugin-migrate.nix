{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "poetry-plugin-migrate";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyf722";
    repo = "poetry-plugin-migrate";
    tag = finalAttrs.version;
    hash = "sha256-/FT053iqd4AgX7hINrGQHrED/ZegDvNSm1P/FfjNHzU=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  pythonImportsCheck = [ "poetry_plugin_migrate" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Poetry plugin to migrate pyproject.toml from Poetry v1 to v2 (PEP-621 compliant)";
    homepage = "https://github.com/zyf722/poetry-plugin-migrate";
    changelog = "https://github.com/zyf722/poetry-plugin-migrate/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zevisert ];
  };
})
