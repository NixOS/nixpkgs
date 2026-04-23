{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "minimax-mcp";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "MiniMax-AI";
    repo = "MiniMax-MCP";
    rev = "1a53cf1";
    hash = "sha256-pi9QMEdgJ5HYn7MNulsQ3kn93OtBGad8Ehojc8apAEs=";
  };

  pyproject = true;
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    mcp
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
    maintainers = with lib.maintainers; [ superherointj ];
    mainProgram = "minimax-mcp";
  };
})
