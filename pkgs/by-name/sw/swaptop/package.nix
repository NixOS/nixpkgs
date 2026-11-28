{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "swaptop";
  version = "1.0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "luis-ota";
    repo = "swaptop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qDAcGJWJYXC1dJIHanmYc1mAFCQ2UgzlnWm2qVjpxog=";
  };

  cargoHash = "sha256-MZg04YIFiFuYd3vsVeBD8n4jo+mBogZKCNV+dCPAxd8=";

  # has no cli commands like --help --version

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/luis-ota/swaptop/releases/tag/${finalAttrs.src.tag}";
    description = "Swap usage monitor written in rust";
    homepage = "https://github.com/luis-ota/swaptop";
    license = lib.licenses.mit;
    mainProgram = "swaptop";
    maintainers = with lib.maintainers; [
      phanirithvij
    ];
    platforms = lib.platforms.linux;
  };
})
