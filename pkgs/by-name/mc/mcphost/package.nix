{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnPabs21TS9SfpJBQ2g8AHJPoDnlxmZM/HKWcLPcwFg=";
  };

  vendorHash = "sha256-0Q9Rn4K3wiZ2tQ2mP2Uh+Hjg1gAFE+AbJR/LA39C8Xs=";

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcphost";
  };
})
