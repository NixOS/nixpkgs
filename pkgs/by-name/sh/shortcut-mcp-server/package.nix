{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "shortcut-mcp-server";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "useshortcut";
    repo = "mcp-server-shortcut";
    tag = "v0.22.0";
    hash = "sha256-ixIll7lYJcYVRSUhoil+Qx7yULxBaNzhDI71afuF/bs=";
  };

  npmDepsHash = "sha256-xhfbx9hWv5UKzUryJG0g7m3tpOSW4wxX4uNoiC23EhQ=";

  # Dependency resolution issue occur during install phase using bun as a dev Dependency
  patches = [ ./remove-bun-dep.patch ];

  meta = {
    description = "MCP server for Shortcut";
    homepage = "https://github.com/useshortcut/mcp-server-shortcut";
    changelog = "https://github.com/useshortcut/mcp-server-shortcut/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kashw2 ];
    mainProgram = "mcp-server-shortcut";
  };
})
