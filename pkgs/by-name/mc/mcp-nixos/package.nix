{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcp-nixos";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${version}";
    hash = "sha256-IizzqlxcNNLjwWPCQezrG+74uDANZ6wexLXSd9XnKP0=";
  };

  patches = [
    # This patch mocks nix channel listing network calls in tests
    ./tests-mock-nix-channels.patch
  ];

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    beautifulsoup4
    (fastmcp.overridePythonAttrs (old: {
      pythonRelaxDeps = (old.pythonRelaxDeps or [ ]) ++ [ "mcp" ];
      doCheck = false; # Skip tests due to mcp version incompatibility
    }))
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
    # Requires network access
    "tests/test_integration.py"
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
