{
  fetchPypi,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "codecov-cli";
  version = "9.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jaljYA2x2nZUOn9vy/CdtxfGjQKHtrtY13WmBdsICTA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "httpx"
    "responses"
    "tree-sitter"
  ];

  dependencies = with python3Packages; [
    click
    httpx
    ijson
    pyyaml
    regex
    responses
    test-results-parser
    tree-sitter
  ];

  meta = {
    description = "Codecov Command Line Interface";
    homepage = "https://github.com/codecov/codecov-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
