{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "sphinxygen";
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "sphinxygen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-54D7h6JCsUEh3y6WmpSaMFlRBElve1lscbQtJz+OJTQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  pythonImportsCheck = [ "sphinxygen" ];

  meta = {
    description = "Generates Sphinx markup from an XML description extracted by Doxygen";
    homepage = "https://gitlab.com/drobilla/sphinxygen";
    changelog = "https://gitlab.com/drobilla/sphinxygen/-/releases/v${finalAttrs.version}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ samueltardieu ];
    mainProgram = "sphinxygen";
  };
})
