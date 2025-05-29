{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4vKzrT/1pEupiW3IaQV6d4Y2QHKNBH8sCA4TP8qn+50=";
  };

  vendorHash = "sha256-yD+83cuOIBFF91Zu4Xi2g+dsP4iUOTrjBOuetowLRQw=";

  meta = {
    description = "A CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "mcphost";
  };
})
