{
  lib,
  python3Packages,
  fetchFromGitHub,
  fetchPypi,
}:
let
  # Due to bug:
  # https://github.com/codecov/codecov-cli/issues/721
  click_8_2 = python3Packages.click.overridePythonAttrs (old: rec {
    version = "8.2.1";
    src = fetchPypi {
      pname = "click";
      inherit version;
      hash = "sha256-J8SRzAXZaNJx1aHbE+O1oYRjbZ2TDxSMULA48NBkYgI=";
    };
  });
in

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
    "responses"
  ];

  dependencies = with python3Packages; [
    click_8_2
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
