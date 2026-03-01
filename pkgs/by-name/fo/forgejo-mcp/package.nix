{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "forgejo-mcp";
  version = "2.11.0";

  src = fetchFromCodeberg {
    owner = "goern";
    repo = "forgejo-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mOxIMK4oke9MfKyirupw/b5ozG+1ZgUZP8vr2UTVfDo=";
  };

  vendorHash = "sha256-j5o/FZBowQvcatw14Fvs/8CTM5ZtQR6kwlroctaeKuM=";

  ldflags = [
    "-s"
    "-X main.Version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Model Context Protocol (MCP) server for interacting with the Forgejo REST API";
    longDescription = "This Model Context Protocol (MCP) server provides tools and resources for interacting with the Forgejo (specifically Codeberg.org) REST API";
    homepage = "https://codeberg.org/goern/forgejo-mcp";
    changelog = "https://codeberg.org/goern/forgejo-mcp/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "forgejo-mcp";
  };
})
