{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crates-lsp";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "MathiasPius";
    repo = "crates-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+0qgdUn5l9oQQavbnR6rHe5zp5WHhGuRyOXt2Dv8Tw=";
  };

  cargoHash = "sha256-oS6xi8BH5vCVOimYWsDoW0Na7eUXzeHKKSOwpK9wbu8=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server implementation for Cargo.toml";
    homepage = "https://github.com/MathiasPius/crates-lsp";
    changelog = "https://github.com/MathiasPius/crates-lsp/blob/v${finalAttrs.version}/CHANGELOG.md";
    mainProgram = "crates-lsp";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    platforms = lib.platforms.all;
  };
})
