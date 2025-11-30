{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "import-linter";
  version = "2.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "import_linter";
    hash = "sha256-2PLcZDKXXMNe3EzAv88bgR8FUAs3fODD9icp1o9Gxpg=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    grimp
    typing-extensions
  ];

  meta = {
    description = "Enforces rules for the imports within and between Python packages";
    homepage = "https://github.com/seddonym/import-linter/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sloschert ];
    mainProgram = "lint-imports";
  };

}
