{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "gitlab-mcp";
  version = "2.1.30";

  src = fetchFromGitHub {
    owner = "zereight";
    repo = "gitlab-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oplROpzyAgKIOSnd5USJBD3tLtPPC1Nohe2Zviyf/aU=";
  };

  npmDepsHash = "sha256-hS8oJEXsN1C3KjIb5fdcqMkJ4rG/dR+heHyIVtYy93M=";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/zereight/gitlab-mcp/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "A comprehensive GitLab MCP server for AI clients";
    homepage = "https://github.com/zereight/gitlab-mcp";
    license = lib.licenses.mit;
    mainProgram = "mcp-gitlab";
    maintainers = with lib.maintainers; [ dvcorreia ];
  };
})
