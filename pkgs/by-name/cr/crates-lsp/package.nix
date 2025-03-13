{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "crates-lsp";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MathiasPius";
    repo = "crates-lsp";
    rev = "v${version}";
    hash = "sha256-331HbziZPb+y292mlElQec8VKzL2afVAZ/QY3iMdPo8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-9yqataKfh/FrBEONkDG+B2HsH8q4MxV/UEeiGVen1vE=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server implementation for Cargo.toml";
    homepage = "https://github.com/MathiasPius/crates-lsp";
    changelog = "https://github.com/MathiasPius/crates-lsp/blob/v${version}/CHANGELOG.md";
    mainProgram = "crates-lsp";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.kpbaks ];
    platforms = lib.platforms.all;
  };
}
