{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "claude-code-acp";
  version = "0.10.3";

  src = fetchFromGitHub {
    owner = "zed-industries";
    repo = "claude-code-acp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f9NGkSH3+4jB5lyol0iQ/EvCvM+vmJLsMrfgxhYeAHA=";
  };

  npmDepsHash = "sha256-I5/f4H/aW+lexBriVZoqIzbhwmdW1eZTMZftoE9XaAs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ACP-compatible coding agent powered by the Claude Code SDK";
    homepage = "https://github.com/zed-industries/claude-code-acp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ storopoli ];
    mainProgram = "claude-code-acp";
  };
})
