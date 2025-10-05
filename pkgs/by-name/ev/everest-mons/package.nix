{
  lib,
  fetchPypi,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "everest-mons";
  version = "2.0.0";

  src = fetchPypi {
    inherit version;
    pname = "mons";
    hash = "sha256-E1yBTwZ4T2C3sXoLGz0kAcvas0q8tO6Aaiz3SHrT4ZE=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];
  pyproject = true;
  dependencies = with python3Packages; [
    dnfile
    pefile
    click
    tqdm
    xxhash
    pyyaml
    urllib3
    platformdirs
  ];

  pythonImportsCheck = [ "mons" ];
  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];
  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    homepage = "https://mons.coloursofnoise.ca/";
    description = "Commandline Everest installer and mod manager for Celeste";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    mainProgram = "mons";
  };
}
