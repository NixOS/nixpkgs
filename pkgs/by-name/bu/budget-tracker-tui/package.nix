{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "budget-tracker-tui";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget_tracker_tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KCF53rA8ij3/jo1pjvqA5p5hSgl2miqeI8X7wkkOaHk=";
  };
  cargoHash = "sha256-2cDXd827wZC4FT0FhGuMtHXJgMY/bHj5NDU71Zro+vs=";

  meta = {
    homepage = "https://github.com/Feromond/budget_tracker_tui";
    description = "Terminal User Interface (TUI) budget tracker";
    changelog = "https://github.com/Feromond/budget_tracker_tui/releases/tag/v${finalAttrs.version}";
    mainProgram = "Budget_Tracker";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.kruziikrel13 ];
  };
})
