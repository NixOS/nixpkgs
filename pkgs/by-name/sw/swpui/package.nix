{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swpui";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "beeb";
    repo = "swpui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/UojnHph71H7mhinCi+uQDhkKkh20JdcHjiF1R7SE3A=";
  };

  cargoHash = "sha256-jaI5jX5hdyZu15oObp+vx4P0OxW/3q2Pg4aQzSJySLY=";

  meta = {
    description = "TUI utility to search and replace with a focus on ergonomics, speed and case-awareness";
    homepage = "https://github.com/beeb/swpui";
    changelog = "https://github.com/beeb/swpui/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ beeb ];
    mainProgram = "swp";
  };
})
