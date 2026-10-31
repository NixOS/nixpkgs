{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "budget-tracker-tui";
  version = "1.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget_tracker_tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WflCwLK4GI0UOzpJGnZBpNd1EDoxn/+wTgNz4HXfbaY=";
  };
  cargoHash = "sha256-zWL9LH83iz/bgodo19Pfitiuqj5Q5M93AgMOFwRErxk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Feromond/budget_tracker_tui";
    description = "Terminal User Interface (TUI) budget tracker";
    changelog = "https://github.com/Feromond/budget_tracker_tui/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "Budget_Tracker";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
