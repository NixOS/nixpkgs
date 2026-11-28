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
  version = "1.8.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Feromond";
    repo = "budget-tracker-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yijS3Tqu57StLuVfdtrGl43+PbobsrZmCAoG/w1Aypg=";
  };
  cargoHash = "sha256-FDIM5myGO8Dw6ITE/A9XbIhtsI73dZRTsSQb4Y4vYJQ=";

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
