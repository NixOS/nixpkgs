{
  lib,
  python3Packages,
  fetchFromGitHub,
  coqPackages,
}:

let
  # Test data for TestMiniF2FSample; the test reads it via MINIF2F_WORKSPACE.
  minif2f = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "miniF2F-rocq";
    rev = "d9480b5e4711a4a8e8334dad3ef2e72c2ec0efdd";
    hash = "sha256-3wMOF7gJ/UgPjbnnwlG3ky0MSCbBEUEOc8qT4fl67JU=";
  };
in

python3Packages.buildPythonApplication {
  pname = "rocq-mcp";
  version = "0.3.1-unstable-2026-07-21";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "rocq-mcp";
    rev = "5a6afcd78e442ab022b6e66c13f66cfb3a9297c9";
    hash = "sha256-zBN3lSawh9l9dZsb0PT+Pw3Yx2aSSarPzA4zTXCLYvA=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    fastmcp
    psutil
    pytanque
  ];

  nativeCheckInputs = [
    # coqc (coq) and pet/pet-server (coq-lsp) let the full compile/interactive
    # suite run, not just the mock-backed unit tests.
    coqPackages.coq
    coqPackages.coq-lsp
    python3Packages.pytestCheckHook
    python3Packages.pytest-asyncio
  ];

  # The Rocq stdlib is a separate library since Rocq 9.0. As a checkInput, the
  # coq setup hook adds it to ROCQPATH so `From Stdlib Require Import ...`
  # resolves for both coqc and pet.
  checkInputs = [ coqPackages.stdlib ];

  env.MINIF2F_WORKSPACE = "${minif2f}";

  pythonImportsCheck = [ "rocq_mcp" ];

  meta = {
    description = "MCP server for Rocq/Coq proof development";
    homepage = "https://github.com/LLM4Rocq/rocq-mcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
    mainProgram = "rocq-mcp";
  };
}
