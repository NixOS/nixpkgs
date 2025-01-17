{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "5.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jAoibszDpQJjiNCZDhX3fLniALOG7r9YqaYEySkmMM4=";
  };

  nativeBuildInputs = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    click
    click-completion
    click-didyoumean
  ];

  # disable tests (too many failures)
  doCheck = false;

  meta = with lib; {
    description = "Tool for live presentations in the terminal";
    homepage = "https://github.com/sloria/doitlive";
    changelog = "https://github.com/sloria/doitlive/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mbode ];
    mainProgram = "doitlive";
  };
}
