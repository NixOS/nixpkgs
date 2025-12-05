{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mcphost";
  version = "0.31.4";

  src = fetchFromGitHub {
    owner = "mark3labs";
    repo = "mcphost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iVcoNOCD8g0HDrp4agK8m7gv4DkcYekdRlPpN41Wrf0=";
  };

  vendorHash = "sha256-4qioHQXdikYItQkYlyXp/Qtuun8FICxyzyWQx/mTSpA=";

  doCheck = false;

  meta = {
    description = "CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP)";
    homepage = "https://github.com/mark3labs/mcphost";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mcphost";
  };
})
