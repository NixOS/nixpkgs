{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-lsVd4CUH1DD6tDYNwfAxOACI0zPvUUaen26GJG6THHc=";
  };

  cargoHash = "sha256-DRJ+TtGMduU3dDy+BKA9XauzYZMGPDS19DB5VvOIBjI=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
