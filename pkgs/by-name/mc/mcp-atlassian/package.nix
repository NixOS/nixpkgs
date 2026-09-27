{
  fetchFromGitHub,
  lib,
  python3Packages,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mcp-atlassian";
  version = "0.24.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ys4suJh9mZ+ezLp2n8tWwb9zFKqb/FKxey5sH9xFPbI=";
  };

  build-system = with python3Packages; [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = with python3Packages; [
    atlassian-python-api
    beautifulsoup4
    cachetools
    click
    fakeredis
    fastmcp
    httpx
    keyring
    markdown
    markdown-to-confluence
    markdownify
    mcp
    pydantic
    python-dateutil
    python-dotenv
    requests
    starlette
    thefuzz
    trio
    truststore
    types-python-dateutil
    tzdata
    unidecode
    urllib3
    uvicorn
  ];

  pythonRelaxDeps = [ "fakeredis" ];

  # types-cachetools is obsolete for cachetools >=7.1.
  pythonRemoveDeps = [ "types-cachetools" ];

  nativeCheckInputs = with python3Packages; [
    pypac
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  disabledTestPaths = [
    # This invokes uv to manage a separate development environment.
    "tests/unit/test_stdio_lifecycle.py"
  ];

  pythonImportsCheck = [ "mcp_atlassian" ];

  meta = {
    description = "MCP server for Atlassian products";
    homepage = "https://github.com/sooperset/mcp-atlassian";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    mainProgram = "mcp-atlassian";
  };
})
