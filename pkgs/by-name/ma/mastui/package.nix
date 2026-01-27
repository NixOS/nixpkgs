{
  lib,
  rustPlatform,
  fetchFromGitea,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mastui";
  version = "0-unstable-2025-07-31";

  src = fetchFromGitea {
    domain = "git.andmc.ca";
    owner = "rozodru";
    repo = "mastui";
    rev = "724f078cb1542f2873f77598979738dc48bec904";
    hash = "sha256-sfuaG5t2vBlsuK6SoK2Il1ohcllSzJFJ2j88iHOgifc=";
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
