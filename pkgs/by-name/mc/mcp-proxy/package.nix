{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "mcp-proxy";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sparfenyuk";
    repo = "mcp-proxy";
    tag = "v${version}";
    sha256 = "sha256-xHy+IwnUoyICSTusqTzGf/kOvT0FvJYcTT9Do0C5DiY=";
  };

  pyproject = true;

  nativeBuildInputs = [ python3Packages.setuptools ];

  propagatedBuildInputs = with python3Packages; [
    uvicorn
    mcp
  ];

  meta = {
    description = "MCP server which proxies other MCP servers from stdio to SSE or from SSE to stdio.";
    homepage = "https://github.com/sparfenyuk/mcp-proxy";
    mainProgram = "mcp-proxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keyruu ];
  };
}
