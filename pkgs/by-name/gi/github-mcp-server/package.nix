{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "github-mcp-server";
  version = "0.30.3";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RqTwii79h7Kk1bpJT1uGG2ODZE5DtROZZyMDKvH3jmo=";
  };

  vendorHash = "sha256-rv7mZQ2/j4R9s3p+Psq5E2I99zFtnieGc3eaMT3ykqQ=";

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
