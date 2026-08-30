{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith-mcp";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "norgolith";
    repo = "core";
    tag = "norgolith-mcp-v${finalAttrs.version}";
    hash = "sha256-YaJ+VMtEZksiGvEaDUVrvOxtV/qxTUSQGDLiEBQ8OP8=";
  };

  cargoHash = "sha256-dxWsMsOmTS5g8pKLw6Vtv5NyJtrRzkiPlBCq2WPRw/M=";

  cargoRoot = "norgolith-mcp";
  buildAndTestSubdir = "norgolith-mcp";

  meta = {
    description = "MCP (Model Context Protocol) server for Norgolith documentation";
    homepage = "https://norgolith.dev";
    changelog = "https://github.com/norgolith/core/releases/tag/norgolith-mcp-v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.Ladas552 ];
    mainProgram = "norgolith-mcp";
  };
})
