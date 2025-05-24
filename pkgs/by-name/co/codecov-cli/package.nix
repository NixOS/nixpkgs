{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "codecov-cli";
  version = "10.4.0";
  pyproject = true;

  src =
    (fetchFromGitHub {
      owner = "codecov";
      repo = "codecov-cli";
      tag = "v${version}";
      hash = "sha256-R1GFQ81N/e2OX01oSs8Xs+PM0JKVZofiUPADVdxCzWk=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  build-system = with python3Packages; [ setuptools ];

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
    sentry-sdk
    wrapt
  ];

  meta = {
    description = "Codecov Command Line Interface";
    homepage = "https://github.com/codecov/codecov-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
