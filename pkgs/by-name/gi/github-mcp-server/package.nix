{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "github-mcp-server";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yiJqQ+oHXvVC9S78Wj2/xeRMyuD3VA0Wt9gZvzHxNFE=";
  };

  vendorHash = "sha256-np5xPpMrJWBRmVU1dJH3wjUZZ0gYRohlSYkk7yrxWWE=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/github/github-mcp-server/releases/tag/v${finalAttrs.version}";
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = lib.licenses.mit;
    mainProgram = "github-mcp-server";
    maintainers = with lib.maintainers; [ logger ];
  };
})
