{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "github-mcp-server";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vX5Ube5sijow8WAf5XgOs7qT4/LHuDZRESD16bAhOc8=";
  };

  vendorHash = "sha256-Vh8wLzCM38kjlF5W4gvoUqyVEQLlQPaxKAPEXek1Dl8=";

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
  versionCheckProgramArg = "--version";

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
