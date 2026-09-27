{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "budget-tracker-tui";
  version = "1.6.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget_tracker_tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1nFR98jMXa164C1/tUwZsFTYxsdDpSudL3eYsrVbvcA=";
  };
  cargoHash = "sha256-Vt/vtzaErGL6fa0nSMlo3cm0ES3ttOAz6uaGu2F6FyQ=";

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
