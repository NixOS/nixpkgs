{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WvoBQLrs9lcbaTueyIPI89Y2t37mKxlE0tOczLhw8Bg=";
  };

  vendorHash = "sha256-xZ7JbX1sAt2ZtgSMm86MQEJWwjL17O9LMsjOmkhzWt0=";

  doCheck = false;

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcphost";
  };
})
