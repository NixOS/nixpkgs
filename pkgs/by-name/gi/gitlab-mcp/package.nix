{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "gitlab-mcp";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "zereight";
    repo = "gitlab-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zS3Y5Icm0Hd2ntCgRHwp19XrF8m/hrz9/PtSIviYElk=";
  };

  npmDepsHash = "sha256-M0AOUINuMsUel+WMGBsJJ26cavzM8+rRF05yTqPgVmk=";

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
