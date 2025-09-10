{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${version}";
    hash = "sha256-NFy38FrU4N+bk4qGyRnrpf2AaBrlQyC9SyRbCLm/d9Y=";
  };

  patches = [
    # This patch mocks nix channel listing network calls in tests
    ./tests-mock-nix-channels.patch
  ];

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    fastmcp
    mcp
    requests
  ];

  pythonRelaxDeps = [ "fastmcp" ];

  nativeCheckInputs = with python3Packages; [
    anthropic
    pytestCheckHook
    pytest-asyncio
    python-dotenv
  ];

  disabledTestMarks = [
    # Require network access
    "integration"
  ];

  disabledTestPaths = [
    # Require network access
    "tests/test_nixhub.py"
    "tests/test_mcp_behavior.py"
    "tests/test_options.py"
    # Requires configured channels
    "tests/test_channels.py"
  ];

  pythonImportsCheck = [ "mcp_nixos" ];

  meta = {
    description = "MCP server for NixOS";
    homepage = "https://github.com/utensils/mcp-nixos";
    changelog = "https://github.com/utensils/mcp-nixos/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "mcp-nixos";
  };
}
