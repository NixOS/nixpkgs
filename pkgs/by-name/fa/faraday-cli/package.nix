{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "faraday-cli";
  version = "2.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "infobyte";
    repo = "faraday-cli";
    tag = version;
    hash = "sha256-TZABx76ap4mzZ99Xd8chkwBsGmT9qJWAeMaubUwGiRw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
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

  pythonImportsCheck = [ "faraday_cli" ];

  meta = {
    description = "Command Line Interface for Faraday";
    homepage = "https://github.com/infobyte/faraday-cli";
    changelog = "https://github.com/infobyte/faraday-cli/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "faraday-cli";
  };
}
