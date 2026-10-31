{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
let
  pythonPackages = python3Packages.overrideScope (
    final: prev: {
      # mcp v2 breaks fastmcp-slim
      mcp = final.mcp_1;
    }
  );
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-nixos";
  version = "3.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "utensils";
    repo = "mcp-nixos";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dugBcQqUWItvuO3VYFANm/istcVwGilwzZ33cfaSW3g=";
  };

  build-system = [ pythonPackages.hatchling ];

  dependencies = with pythonPackages; [
    beautifulsoup4
    fastmcp
    requests
  ];

  nativeCheckInputs = with pythonPackages; [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_integration.py"
  ];

  pythonImportsCheck = [ "mcp_nixos" ];

  meta = {
    description = "MCP server for NixOS";
    homepage = "https://github.com/utensils/mcp-nixos";
    changelog = "https://github.com/utensils/mcp-nixos/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "mcp-nixos";
  };
})
