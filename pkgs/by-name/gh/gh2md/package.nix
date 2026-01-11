{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "gh2md";
  version = "2.5.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-01r/x9SrxCUN/wrEAWopHDAEEJdwKiWL9mERylaNAlA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    six
    requests
    python-dateutil
  ];

  # uses network
  doCheck = false;

  pythonImportsCheck = [ "gh2md" ];

  meta = {
    description = "Export Github repository issues to markdown files";
    mainProgram = "gh2md";
    homepage = "https://github.com/mattduck/gh2md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artturin ];
  };
}
