{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sphinxygen";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "sphinxygen";
    rev = "v${version}";
    hash = "sha256-TIACg89E/BaMwPgFqj6JUncq7BI5xQ9jUDe4nQ9YiI4=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  pythonImportsCheck = [ "sphinxygen" ];

  meta = {
    description = "Generates Sphinx markup from an XML description extracted by Doxygen";
    homepage = "https://gitlab.com/drobilla/sphinxygen";
    changelog = "https://gitlab.com/drobilla/sphinxygen/-/releases/v${version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ samueltardieu ];
    mainProgram = "sphinxygen";
  };
}
