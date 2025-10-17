{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crates-lsp";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "MathiasPius";
    repo = "crates-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-s42nWQC2tD7vhQNPdTQNRokwXqeBhELidVYTlos+No0=";
  };

  cargoHash = "sha256-XqUWcbaOZXRWzIvL9Kbo6Unl0rmeGxHO4+674uHukAs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server implementation for Cargo.toml";
    homepage = "https://github.com/MathiasPius/crates-lsp";
    license = with lib.licenses; [ mit ];

    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-windows"
    ];
    maintainers = with lib.maintainers; [ steveej ];
    mainProgram = "crates-lsp";
  };
})
