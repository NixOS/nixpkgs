{
  lib,
  python3Packages,
  fetchFromGitLab,
}:

python3Packages.buildPythonApplication rec {
  pname = "pricehist";
  version = "1.4.14";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "chrisberkhout";
    repo = "pricehist";
    tag = version;
    hash = "sha256-BnyoSYVjs2odnOzSpvgMF860PDkz7tPNnM0s3Fep5G0=";
  };

  dependencies = with python3Packages; [
    requests
    lxml
    cssselect
    curlify
  ];

  pythonRelaxDeps = [
    "lxml"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  nativeCheckInputs = with python3Packages; [
    responses
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    description = "Command-line tool for fetching and formatting historical price data, with support for multiple data sources and output formats";
    homepage = "https://gitlab.com/chrisberkhout/pricehist";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iedame ];
    mainProgram = "pricehist";
  };
}
