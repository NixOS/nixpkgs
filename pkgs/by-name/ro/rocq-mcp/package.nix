{
  lib,
  python3Packages,
  fetchFromGitHub,
  rocqPackages,
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
  version = "0.3.1-unstable-2026-08-05";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LLM4Rocq";
    repo = "rocq-mcp";
    rev = "6983113d0844c0b7f987c79dab13988445109bfb";
    hash = "sha256-rFtpCnrudC5U3PlL8WfYk23id7T1v1+xL+xQq+riWXY=";
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
    # coqc (coq) and pet (coq-lsp) let the compile and interactive tests run
    # against real binaries instead of mocks.
    rocqPackages.coq
    rocqPackages.coq-lsp
    python3Packages.pytestCheckHook
    python3Packages.pytest-asyncio
  ];

  # Rocq 9.0 split out the stdlib. The setup hook fires over buildInputs, so
  # stdlib has to be a checkInput to reach ROCQPATH.
  checkInputs = [ rocqPackages.stdlib ];

  # rocq_compile refuses a workspace it cannot write to, and the test passes on
  # the resulting error dict, so a store path would compile nothing.
  preCheck = ''
    cp -r --no-preserve=mode ${minif2f} minif2f
    export MINIF2F_WORKSPACE=$PWD/minif2f
  '';

  pythonImportsCheck = [ "rocq_mcp" ];

  meta = {
    description = "MCP server for Rocq/Coq proof development";
    longDescription = ''
      rocq-mcp resolves coqc and pet from PATH at run time, so that it drives
      whichever Rocq switch the user already works in. Install rocqPackages.coq
      and rocqPackages.coq-lsp alongside it, otherwise its tools have nothing
      to drive.
    '';
    homepage = "https://github.com/LLM4Rocq/rocq-mcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ remix7531 ];
    mainProgram = "rocq-mcp";
  };
}
