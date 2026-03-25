{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "forgejo-mcp";
  version = "2.16.0";

  src = fetchFromCodeberg {
    owner = "goern";
    repo = "forgejo-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LiLzkpbNqY8YKhsDt1Y6SrI28YEAy2KWQiw206Q4MbQ=";
  };

  vendorHash = "sha256-tQyZqtmJnbVIG8lpWeZjflv92OdOdmzJXAmq4xrI5Pw=";

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
