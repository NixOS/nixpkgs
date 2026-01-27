{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "canopy";
  version = "0-unstable-2025-11-14";

  src = fetchFromGitHub {
    owner = "hnpf";
    repo = "canopy";
    rev = "b0229e75bc6b662c948e36ed0a0b34c32435ec48";
    hash = "sha256-6Hswmmn4QH5HkvTz94ppmZ9TSh/WBOXhU8yG8COoZHg=";
  };

  cargoHash = "sha256-bXEbt0GotCzVEs8XbtM42nbzzEdHk7aowdI7AgblZ4k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A rust tool to see your files in a structure";
    homepage = "https://github.com/hnpf/canopy";
    changelog = "https://github.com/hnpf/canopy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "canopy";
  };
})
