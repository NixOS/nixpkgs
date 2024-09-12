{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "fichub-cli";
  version = "0.10.3";
  pyproject = true;

  src = fetchPypi {
    pname = "fichub_cli";
    inherit version;
    hash = "sha256-MTExXpuCwi/IfNDUVLMcxfFRwHHNfGJerHkHnh6/hls=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    platformdirs
    beautifulsoup4
    click
    click-plugins
    colorama
    loguru
    requests
    tqdm
    typer
  ];

  pythonImportsCheck = [
    "fichub_cli"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  # The package tries to create a file under the home directory on import
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    # pytest exits with a code of 5 if no tests are selected.
    # handle this specific case as not an error
    "|| ([ $? = 5 ] || exit $?)"
  ];

  disabledTestPaths = [
    # Loading tests tries to download something from pypi.org
    "tests/test_cli.py"
  ];

  meta = {
    description = "CLI for the fichub.net API";
    changelog = "https://github.com/FicHub/fichub-cli/releases/tag/v${version}";
    mainProgram = "fichub_cli";
    homepage = "https://github.com/FicHub/fichub-cli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
