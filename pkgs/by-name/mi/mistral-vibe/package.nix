{
  fetchFromGitHub,
  lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mistral-vibe";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mistralai";
    repo = "mistral-vibe";
    rev = "v${version}";
    hash = "sha256-m9VeTqe6/d9WWXnYqXrUakVMrOda78A38vUm5ABUFPg=";
  };

  build-system = with python3.pkgs; [
    hatch-vcs
    hatchling
  ];

  dependencies = with python3.pkgs; [
    agent-client-protocol
    aiofiles
    httpx
    mcp
    mistralai
    packaging
    pexpect
    pydantic
    pydantic-settings
    pyperclip
    python-dotenv
    rich
    textual
    textual-speedups
    tomli-w
    watchfiles
  ];

  pythonRelaxDeps = [
    "agent-client-protocol"
    "pydantic-settings"
    "pydantic"
    "watchfiles"
  ];

  pythonImportsCheck = [ "vibe.cli.entrypoint" ];

  # The package tries to create a log directory at import time
  # We need to set HOME to a writable directory for the import check
  preInstallCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = " Minimal CLI coding agent";
    homepage = "https://github.com/mistralai/mistral-vibe";
    license = licenses.asl20;
    maintainers = with lib.maintainers; [ shikanime ];
    mainProgram = "vibe";
  };
}
