{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith-mcp";
  version = "1.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-mcp-v${finalAttrs.version}";
    hash = "sha256-XCcycFHAi3NAVGg7toCLMkVylV0kTAUb5CkLmvplR1w=";
  };

  cargoHash = "sha256-i9noy9F/qitOKGbSCjxyey0rYzNOVNfWLPrdPOLZvGk=";

  cargoRoot = "norgolith-mcp";
  buildAndTestSubdir = "norgolith-mcp";

  meta = {
    description = "MCP (Model Context Protocol) server for Norgolith documentation";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "norgolith-mcp";
  };
})
