{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-cli";
  version = "2.1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-bCiiX5dYodnWkKeNo2j3PGMz17F5y2X4ECZiStDdK5U=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    arrow
    click
    cmd2
    colorama
    faraday-plugins
    jsonschema
    log-symbols
    luddite
    packaging
    pyyaml
    py-sneakers
    simple-rest-client
    spinners
    tabulate
    termcolor
    validators
  ];

  # Tests requires credentials
  doCheck = false;

  pythonImportsCheck = [
    "faraday_cli"
  ];

  meta = with lib; {
    description = "Command Line Interface for Faraday";
    mainProgram = "faraday-cli";
    homepage = "https://github.com/infobyte/faraday-cli";
    changelog = "https://github.com/infobyte/faraday-cli/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
