{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "lean-lsp-mcp";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "lean-lsp-mcp";
    tag = "v${version}";
    hash = "sha256-hCEbVoxiUBRysDiNvZyx9nZTxbaAQsgsQTiQvhyLosM=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    leanclient
    mcp
  ];

  dontCheckRuntimeDeps = true;

  meta = {
    description = "Lean Theorem Prover MCP (Model Context Protocol) server";
    longDescription = ''
      A Model Context Protocol (MCP) server that provides access to Lean 4 theorem prover
      functionality. This allows AI assistants and other tools to interact with Lean projects,
      query definitions, and get theorem proving assistance.
    '';
    homepage = "https://github.com/oOo0oOo/lean-lsp-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wvhulle ];
    mainProgram = "lean-lsp-mcp";
  };
}
