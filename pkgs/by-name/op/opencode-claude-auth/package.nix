{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "opencode-claude-auth";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "griffinmartin";
    repo = "opencode-claude-auth";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ntqMpyXOyOvtZVbe5nZmQ3COxW3kM7IG8CCUbGWYYEk=";
  };

  npmDepsHash = "sha256-j4h/PUVWcgW9XRnaUqpMSdfb9TZtQfp1cOfxwG4FX5A=";

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
