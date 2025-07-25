{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "gitup";
  version = "0.5.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-51DWPJ9JOMrRdWGaiiL4qzo4VFFeT1rG5yyI6Ej+ZRw=";
  };

  build-system = with python3Packages; [ hatchling ];

  propagatedBuildInputs = with python3Packages; [
    colorama
    gitpython
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Easily update multiple Git repositories at once";
    homepage = "https://github.com/earwig/git-repo-updater";
    license = licenses.mit;
    maintainers = with maintainers; [
      bdesham
      artturin
    ];
    mainProgram = "gitup";
  };
}
