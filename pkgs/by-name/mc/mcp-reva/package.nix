{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-reva";
  version = "7.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cyberkaida";
    repo = "reverse-engineering-assistant";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5DVHEcZHq7Thi4L1OJuaOwK/nAqntolYCBEE2acHNHw=";
  };

  # setuptools_scm derives the version from git tags, which the tarball lacks.
  env.SETUPTOOLS_SCM_PRETEND_VERSION = finalAttrs.version;

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    pyghidra
    mcp
    httpx
    httpx-sse
  ];

  # The test suite drives a real Ghidra installation through PyGhidra.
  doCheck = false;

  pythonImportsCheck = [ "reva_cli" ];

  meta = {
    description = "Headless MCP server exposing Ghidra to AI agents";
    longDescription = ''
      ReVa's headless command-line interface. It starts and manages Ghidra
      through PyGhidra and bridges it to an MCP client over stdio, so MCP
      clients can drive Ghidra's decompiler and analysis APIs. Point
      GHIDRA_INSTALL_DIR at the Ghidra installation to use.
    '';
    homepage = "https://github.com/cyberkaida/reverse-engineering-assistant";
    changelog = "https://github.com/cyberkaida/reverse-engineering-assistant/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.brianmcgillion ];
    mainProgram = "mcp-reva";
  };
})
