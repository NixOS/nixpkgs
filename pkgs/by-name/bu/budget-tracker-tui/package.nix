{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  pkg-config,
  sqlite,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "budget-tracker-tui";
  version = "1.8.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget-tracker-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j8JK1zBIFJyPp+sT4lB7IX9mB4WLsRiCI2fec4ocYU4=";
  };
  cargoHash = "sha256-IYFzqcvpDu4KrGrJl5T3Sir6MG7b1SFIgdY/8HiAPAg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Feromond/budget-tracker-tui";
    description = "Terminal User Interface (TUI) budget tracker";
    changelog = "https://github.com/Feromond/budget-tracker-tui/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "Budget_Tracker";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ tomasrivera ];
  };
})
