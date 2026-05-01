{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "lean-lsp-mcp";
  version = "0.26.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "lean-lsp-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OHbD6HujkXsqe8XpNr1bn+Pel2tbkX7tBapCcUe234o=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    leanclient
    mcp
    orjson
    certifi
  ];

  pythonRelaxDeps = [
    "mcp"
    "leanclient"
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
