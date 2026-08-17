{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "codecov-cli";
  version = "11.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "prevent-cli";
    tag = "v${version}";
    hash = "sha256-8KBemqwMqiio4pnftsBgnFj69Bgb5jQr5YlMegujPZY=";
  };

  sourceRoot = "${src.name}/${pname}";

  build-system = with python3Packages; [ setuptools ];

  pythonRelaxDeps = [
    "click"
    "responses"
  ];

  dependencies = with python3Packages; [
    click
    ijson
    pyyaml
    responses
    sentry-sdk
    test-results-parser
  ];

  meta = {
    description = "Codecov Command Line Interface";
    homepage = "https://github.com/codecov/codecov-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
}
