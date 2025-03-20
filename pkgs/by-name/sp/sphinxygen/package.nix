{
  lib,
  python3,
  fetchFromGitLab,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sphinxygen";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "drobilla";
    repo = "sphinxygen";
    tag = "v${version}";
    hash = "sha256-Xii5pDa1eHrHUKERC2gDif/NIkpab/IZYBRvMq9YKtE=";
  };

  build-system = with python3.pkgs; [ setuptools ];

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
