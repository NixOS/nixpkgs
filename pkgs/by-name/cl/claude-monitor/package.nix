{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "claude-monitor";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Maciek-roboblog";
    repo = "Claude-Code-Usage-Monitor";
    tag = "v${version}";
    hash = "sha256-v5ooniaN1iVerBW77/00SpghIVE1j8cl2WENcPnS66M=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    numpy
    pydantic
    pydantic-settings
    pyyaml
    pytz
    rich
  ];

  # Tests require Claude API access and local data files
  doCheck = false;

  meta = {
    description = "Real-time Claude Code usage monitor";
    longDescription = ''
      Real-time terminal monitoring tool for Claude AI token usage
      with advanced analytics, machine learning-based predictions,
      and Rich UI. Track your token consumption, burn rate, cost analysis,
      and get intelligent predictions about session limits.
    '';
    homepage = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor";
    changelog = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "claude-monitor";
  };
}
