{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "rocq-mcp";
  version = "0.2.1-unstable-2026-05-06";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "rocq-mcp";
    rev = "612dec76009237e89c52a85bd29c10a75e712831";
    hash = "sha256-UdlwMv+bceC0xLTL+5q2l+1gKYrs6ChKAb01fIC+7dU=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fastmcp
    psutil
    pytanque
  ];

  # Tests require a running pet-server (Petanque/coq-lsp).
  doCheck = false;

  pythonImportsCheck = [ "rocq_mcp" ];

  meta = {
    description = "MCP server for Rocq/Coq proof development";
    homepage = "https://github.com/LLM4Rocq/rocq-mcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
    mainProgram = "rocq-mcp";
  };
}
