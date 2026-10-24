{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mcpm";
  version = "2.15.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pathintegral-institute";
    repo = "mcpm.sh";
    tag = "v${version}";
    hash = "sha256-969MuoEgUvPc5GWNCCctqf7gKYYjXIpX61+X7DatY0Y=";
  };

  # mcpm.cli creates its config directories at import time.
  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    click
    rich
    rich-click
    requests
    pydantic
    mcp
    fastmcp
    ruamel-yaml
    watchfiles
    duckdb
    psutil
    prompt-toolkit
    deprecated
    inquirerpy
    rich-gradient
    tomli
    tomli-w
    jsonschema
  ];

  # Upstream pins pydantic <2.12.0 and fastmcp ==2.13.0, but the APIs mcpm
  # uses (FastMCP.as_proxy, MCPConfig, middleware, get_http_headers) are
  # unchanged in fastmcp 3.x, and pydantic 2.13 works fine.
  pythonRelaxDeps = [
    "pydantic"
    "fastmcp"
  ];

  # mcpm.cli eagerly imports the whole command graph, including the
  # fastmcp integration modules, so this guards the fastmcp 3.x compat.
  pythonImportsCheck = [ "mcpm.cli" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Package manager for Model Context Protocol (MCP) servers";
    homepage = "https://mcpm.sh";
    changelog = "https://github.com/pathintegral-institute/mcpm.sh/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.luochen1990 ];
    mainProgram = "mcpm";
  };
}
