{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "claude-monitor";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Maciek-roboblog";
    repo = "Claude-Code-Usage-Monitor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f/g8OygQYYfZqboTNePwCW3OxcH/wlvsHvL8Cv+iyCU=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    numpy
    pydantic
    pydantic-settings
    pyyaml
    pytz
    rich
    wcwidth
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
    changelog = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "claude-monitor";
  };
})
