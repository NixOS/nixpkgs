{
  lib,
  buildGoModule,
  fetchgit,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "forgejo-mcp";
  version = "3.2.0";

  # Plain git fetch: upstream's Forgejo instance has source-archive
  # downloads disabled, so fetchFromForgejo (tarball-based) cannot be used.
  src = fetchgit {
    url = "https://git.b4mad.industries/agentic-forges/forgejo-mcp.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dZ7k2c0abejHuwdRkXcOMKCnDeY193PYkIg0LVzbvII=";
  };

  vendorHash = "sha256-3RFWaohlUd6RpU531/DQH5wgVtjOi/Lh19Hyget7Bhw=";

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
    longDescription = "This Model Context Protocol (MCP) server provides tools and resources for interacting with the Forgejo REST API";
    homepage = "https://git.b4mad.industries/agentic-forges/forgejo-mcp";
    changelog = "https://git.b4mad.industries/agentic-forges/forgejo-mcp/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      malik
      byteflavour
    ];
    mainProgram = "forgejo-mcp";
  };
})
