{
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "proselint";
  version = "0.14.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "amperser";
    repo = "proselint";
    tag = version;
    hash = "sha256-bI5gkckXUa640GOb5U5NW4i2op4fn0LKoPHFSIwbheM=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = [ python3Packages.click ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "proselint" ];

  meta = {
    description = "Linter for prose";
    mainProgram = "proselint";
    homepage = "https://github.com/amperser/proselint";
    changelog = "https://github.com/amperser/proselint/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.pbsds ];
  };
}
