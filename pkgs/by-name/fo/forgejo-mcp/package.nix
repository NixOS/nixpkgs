{
  lib,
  buildGoModule,
  fetchgit,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "forgejo-mcp";
  version = "3.0.1";

  # Plain git fetch: upstream's Forgejo instance has source-archive
  # downloads disabled, so fetchFromForgejo (tarball-based) cannot be used.
  src = fetchgit {
    url = "https://git.b4mad.industries/agentic-forges/forgejo-mcp.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Cq99Bj9I9oXM00fL9IBGq/EKj7Jv/fODffohR8APeik=";
  };

  vendorHash = "sha256-Za1lwQQr+qeMIokRLSn2ywRg+5GxMS4KEg+99P1YHy0=";

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
    maintainers = with lib.maintainers; [ malik ];
    mainProgram = "forgejo-mcp";
  };
})
