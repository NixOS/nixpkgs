{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bmm";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "bmm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SASf13BFNz4ZlKJJk6O/Euv+wA26ov0QKsaEKRc24d0=";
  };

  cargoHash = "sha256-AOGNMFAr32WZnyw5nNQa6svLpSc3UQonZ7RjZ5zap1I=";

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Get to your bookmarks in a flash";
    homepage = "https://github.com/dhth/bmm";
    changelog = "https://github.com/dhth/bmm/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ faukah ];
    mainProgram = "bmm";
  };
})
