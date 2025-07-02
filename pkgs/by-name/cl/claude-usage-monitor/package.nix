{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "claude-usage-monitor";
  version = "1.0.19-unstable-2024-06-30";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Maciek-roboblog";
    repo = "Claude-Code-Usage-Monitor";
    rev = "39a3b2f598eec1c1d1ec11ecfbe5b12ff7ac63a7";
    hash = "sha256-uW4E0iufYE7jat7nwAJUrcW+bJmZvQxWW9opId7NP/0=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    pytz
    rich
  ];

  # Tests require Claude API access and local data files
  doCheck = false;

  pythonImportsCheck = [
    "usage_analyzer"
  ];

  meta = with lib; {
    description = "Real-time terminal monitoring tool for Claude AI token usage";
    longDescription = ''
      Claude Monitor is a real-time terminal application that tracks Claude AI token
      usage by reading local usage data files. It provides live monitoring of token
      consumption, burn rate analysis, and usage predictions without requiring
      external API access or network connectivity.

      The tool reads usage metadata from local JSONL files that Claude Desktop
      automatically creates, ensuring privacy by only accessing usage statistics
      rather than conversation content.
    '';
    homepage = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor";
    changelog = "https://github.com/Maciek-roboblog/Claude-Code-Usage-Monitor/blob/main/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "claude-monitor";
    platforms = platforms.unix;
  };
}
