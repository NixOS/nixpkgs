{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hackernews-tui";
  version = "0.13.5";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aome510";
    repo = "hackernews-TUI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p2MhVM+dbNiWlhvlSKdwXE37dKEaE2JCmT1Ari3b0WI=";
  };

  cargoHash = "sha256-KuqAyuU/LOFwvvfplHqq56Df4Dkr5PkUK1Fgeaq1REs=";

  meta = {
    description = "A Terminal UI to browse Hacker News";
    homepage = "https://github.com/aome510/hackernews-TUI";
    changelog = "https://github.com/aome510/hackernews-TUI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paepcke ];
    mainProgram = "hackernews-tui";
  };
})
