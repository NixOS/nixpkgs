{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "slack-mcp-server";
  version = "1.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "korotovsky";
    repo = "slack-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-I4f6yKV0BXtaxnqi/XNID+Pwl2mWjSqxIHhb07U7sc4=";
  };

  vendorHash = "sha256-+uQRODO9oL8mGKBmdghTxE6R9Fz+3GJFVTi17306gT8=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/korotovsky/slack-mcp-server/pkg/version.Version=${finalAttrs.version}"
    "-X=github.com/korotovsky/slack-mcp-server/pkg/version.CommitHash=${finalAttrs.src.tag}"
  ];

  # TestGetCacheDir creates the user cache directory.
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # Integration tests talk to a real Slack workspace and need its tokens.
  checkFlags = [ "-skip=^TestIntegration" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MCP server for Slack workspaces, with stealth and OAuth modes";
    homepage = "https://github.com/korotovsky/slack-mcp-server";
    changelog = "https://github.com/korotovsky/slack-mcp-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "slack-mcp-server";
  };
})
