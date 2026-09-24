{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "budget-tracker-tui";
  version = "1.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget_tracker_tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vNpnW9SIjuSnvNtBW8wzDNCCVpw3z/2nv9bremTMqww=";
  };
  cargoHash = "sha256-eMzqi2uEaLmHEQtegiT2aWOJCq0tIdywtv1rl99kyys=";

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
