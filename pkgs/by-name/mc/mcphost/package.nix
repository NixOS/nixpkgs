{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.19.2";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BDG4df7YG5cKjL8zsbvK4xFJMwyjSPx4jnDKwPVm+zw=";
  };

  vendorHash = "sha256-U/XtO4OhcioaSU2iGTNmvEilp9+Yu3TVafzNEaFcWEg=";

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "mcphost";
  };
})
