{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "github-mcp-server";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GXE6ZmCDPjDCpCrrX0DcDdcLVgM+hHVWzihMYqUQaSI=";
  };

  vendorHash = "sha256-SWzKE1pliZd3fQrbh8JpoepT/bKpZHuq7WZ8LEzNn50=";

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

  meta = {
    changelog = "https://github.com/github/github-mcp-server/releases/tag/v${finalAttrs.version}";
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = lib.licenses.mit;
    mainProgram = "github-mcp-server";
    maintainers = with lib.maintainers; [ drupol ];
  };
})
