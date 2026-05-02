{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "codecov-cli";
  version = "11.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "prevent-cli";
    tag = "v${version}";
    hash = "sha256-1CVl8X05e0Fm7TCKlZtQk+o9i26O9KVdnlUIBYqa8IE=";
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
