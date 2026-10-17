{
  lib,
  fetchCrate,
  openssl,
  pkg-config,
  rustPlatform,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fs-watcher-lsp";
  version = "0.1.0";

  src = fetchCrate {
    version = finalAttrs.version;
    crateName = "fs_watcher_lsp";
    hash = "sha256-zahbi8RK8aDHcVOzIk5fCIh57+SjMGAVtUvtKhpMvF0=";
  };

  cargoHash = "sha256-w1i19IV/tjyl+W0NIjjbB0R9UpGrAUuK/yWbOZUKPUA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  buildNoDefaultFeatures = false;
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Little file system watcher LSP to reload your editor";
    changelog = "https://codeberg.org/Zentropivity/fs_watcher_lsp/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ landreussi ];
    mainProgram = "fs_watcher_lsp";
  };
})
