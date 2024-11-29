{
  lib,
  buildPythonPackage,
  black,
  jinja2,
  dirty-equals,
  fastapi,
  fetchFromGitHub,
  fetchpatch,
  pdm-backend,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlmodel";
  version = "0.0.22";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "sqlmodel";
    rev = "refs/tags/${version}";
    hash = "sha256-y6lY6DlfdCF5dliRkiU6r+ny/a9ssDtqRmF+/rcKFkg=";
  };

  patches = [
    (fetchpatch { # https://github.com/tiangolo/sqlmodel/pull/969
      name = "passthru-environ-variables.patch";
      url = "https://github.com/tiangolo/sqlmodel/pull/969/commits/42d33049e9e4182b78914ad41d1e3d30125126ba.patch";
      hash = "sha256-dPuFCFUnmTpduxn45tE8XUP0Jlwjwmwe+zFaKSganOg=";
    })
  ];

  build-system = [ pdm-backend ];

  dependencies = [
    pydantic
    sqlalchemy
  ];

  nativeCheckInputs = [
    black
    jinja2
    dirty-equals
    fastapi
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlmodel" ];

  disabledTests = [
    # AssertionError: assert 'enum_field VARCHAR(1)
    "test_sqlite_ddl_sql"
  ];

  disabledTestPaths = [
    # Coverage
    "docs_src/tutorial/"
    "tests/test_tutorial/"
  ];

  meta = with lib; {
    description = "Module to work with SQL databases";
    homepage = "https://github.com/tiangolo/sqlmodel";
    changelog = "https://github.com/tiangolo/sqlmodel/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
