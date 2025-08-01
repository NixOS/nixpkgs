{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "doitlive";
  version = "5.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-trzSX58De36W401oVJMGrbPoyD9uksUewrIlq8BbJcU=";
  };

  build-system = with python3Packages; [ flit-core ];

  dependencies = with python3Packages; [
    click
    click-completion
    click-didyoumean
  ];

  # disable tests (too many failures)
  doCheck = false;

  meta = {
    description = "Tool for live presentations in the terminal";
    homepage = "https://github.com/sloria/doitlive";
    changelog = "https://github.com/sloria/doitlive/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mbode ];
    mainProgram = "doitlive";
  };
}
