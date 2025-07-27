{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${version}";
    hash = "sha256-NwP+zM1VGLOzIm+mLZVK9/9ImFwuiWhRJ9QK3hGpQsY=";
  };

  patches = [
    # This patch mocks nix channel listing network calls in tests
    ./tests-mock-nix-channels.patch
  ];

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    mcp
    requests
  ];

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
    "tests/test_nixhub_evals.py"
    "tests/test_mcp_behavior_evals.py"
    "tests/test_option_info_improvements.py"
    # Requires configured channels
    "tests/test_dynamic_channels.py"
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
