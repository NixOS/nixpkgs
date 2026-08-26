{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "opencode-claude-auth";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "griffinmartin";
    repo = "opencode-claude-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gUvtvOfJLgcPu5OR+wb8nH5AFp7r5HvuGtTr4fUa+lo=";
  };

  npmDepsHash = "sha256-sEavFoCmzitfZqSVvjSYP2FzwzlY4MCGtnAMWDhSgfU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenCode plugin that uses your existing Claude Code credentials";
    homepage = "https://github.com/griffinmartin/opencode-claude-auth";
    changelog = "https://github.com/griffinmartin/opencode-claude-auth/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
})
