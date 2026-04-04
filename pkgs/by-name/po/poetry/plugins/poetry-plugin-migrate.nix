{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry,
  pytest-mock,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "poetry-plugin-migrate";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zyf722";
    repo = "poetry-plugin-migrate";
    tag = version;
    hash = "sha256-78H4/vHp8W7h6v6OWUdx9pX4142YiNGUFZXHoxxXw1M=";
  };

  build-system = [
    poetry-core
  ];

  buildInputs = [
    poetry
  ];

  pythonImportsCheck = [ "poetry_plugin_migrate" ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Poetry plugin to migrate pyproject.toml from Poetry v1 to v2 (PEP-621 compliant)";
    homepage = "https://github.com/zyf722/poetry-plugin-migrate";
    changelog = "https://github.com/zyf722/poetry-plugin-migrate/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zevisert ];
  };
}
