{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "minimax-mcp";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "MiniMax-AI";
    repo = "MiniMax-MCP";
    rev = "0856b9aef8a9d676bb63bdd6b6426d7b640a3b7a";
    hash = "sha256-5s6pax4dJLec2NlQ4Q/aS4+auScdioFbwxstXtOHXUc=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    mcp_2
    fastapi
    uvicorn
    python-dotenv
    pydantic
    httpx
    fuzzywuzzy
    levenshtein
    sounddevice
    soundfile
    requests
  ];

  pythonImportsCheck = [ "minimax_mcp" ];

  dontCheckRuntimeDeps = true;

  meta = {
    description = "MiniMax MCP Server for text-to-speech, voice cloning, image and video generation";
    longDescription = ''
      A Model Context Protocol (MCP) server for MiniMax that enables
      text-to-speech, voice cloning, image generation, and video generation
      capabilities. Works with MCP clients like Claude Desktop, Cursor, and OpenCode.
    '';
    homepage = "https://github.com/MiniMax-AI/MiniMax-MCP";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "minimax-mcp";
  };
})
