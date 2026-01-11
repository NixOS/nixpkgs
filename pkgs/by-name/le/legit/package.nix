{
  lib,
  python3Packages,
  fetchPypi,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "legit";
  version = "1.2.0.post0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lJOWtoApqK9AWrIMkBkCNB72vVXH/sbatxFB1j1AaxE=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    click
    clint
    crayons
    gitpython
    six
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "legit" ];

  meta = {
    homepage = "https://github.com/frostming/legit";
    description = "Git for Humans, Inspired by GitHub for Mac";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ryneeverett ];
    mainProgram = "legit";
  };
}
