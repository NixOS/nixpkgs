{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

let
  pythonPackages = python3Packages.overrideScope (
    self: super: {
      mcp = self.mcp_2;
    }
  );
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "lean-lsp-mcp";
  version = "0.31.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "lean-lsp-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LUjOgJTGFRcthGjBM3wyeSNAsqziGxTSDA9X1Fjpg8c=";
  };

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    leanclient
    mcp
    orjson
    certifi
  ];

  pythonRelaxDeps = [
    "certifi"
    "leanclient"
    "mcp"
  ];

  # Tests require a real Lean toolchain
  doCheck = false;

  pythonImportsCheck = [ "lean_lsp_mcp" ];

  meta = {
    description = "MCP server for the Lean theorem prover via the Lean LSP";
    homepage = "https://github.com/oOo0oOo/lean-lsp-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ remix7531 ];
    mainProgram = "lean-lsp-mcp";
  };
})
