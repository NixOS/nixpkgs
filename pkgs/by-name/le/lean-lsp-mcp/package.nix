{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "lean-lsp-mcp";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "lean-lsp-mcp";
    tag = "v${version}";
    hash = "sha256-dnu53nUOWWVQZ2RokDqwyJnA0zhuEkeqpEc4VueQumI=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    leanclient
    mcp
  ];

  pythonImportsCheck = false; # Ran into a build error: module `1` not found.
  dontCheckRuntimeDeps = true;
  doCheck = true;

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
