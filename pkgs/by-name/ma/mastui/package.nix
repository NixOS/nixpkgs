{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mastui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "rozodru";
    repo = "mastui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HLjTIAlS7oRya+zTuKf18Q83pqbTrFJ8s211mYlmq64=";
  };

  cargoHash = "sha256-F+w19Suq1vR89y44yBTYRIIyeBtvkefoYLoQ48ChFAk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for Mastodon";
    homepage = "https://github.com/rozodru/Mastui";
    changelog = "https://github.com/rozodru/Mastui/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "mastui";
    platforms = lib.platforms.unix;
  };
})
