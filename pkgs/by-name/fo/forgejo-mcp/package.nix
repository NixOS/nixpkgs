{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "forgejo-mcp";
  version = "2.18.0";

  src = fetchFromCodeberg {
    owner = "goern";
    repo = "forgejo-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KWNRQJHW9+21+azIKjO2ryAPEDS7Ka0BuFnCFIko+FY=";
  };

  vendorHash = "sha256-5CV4drUaYKtZ/RoydAatblhsqU8VWYzYByjhcb9KZVY=";

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
