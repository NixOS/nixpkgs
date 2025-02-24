{
  lib,
  python3Packages,
  fetchPypi,
}:

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

  # Loading tests tries to download something from pypi.org
  doCheck = false;

  meta = {
    description = "CLI for the fichub.net API";
    changelog = "https://github.com/FicHub/fichub-cli/releases/tag/v${version}";
    mainProgram = "fichub_cli";
    homepage = "https://github.com/FicHub/fichub-cli";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.samasaur ];
  };
}
