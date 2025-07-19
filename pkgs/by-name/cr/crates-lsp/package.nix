{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "crates-lsp";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "MathiasPius";
    repo = "crates-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HzoOsizeV2LOXXc8BKA7u5mwBJbWNaBZvPepAaVeTCQ=";
  };

  cargoHash = "sha256-tQBNCTqvVNYqT5ArQE7ji0MeDWxi7Bcd9AxPP3sHvX4=";

  checkFlags = [
    # These tests fail on system `x86_64-darwin` with error:
    # failed to create crates-lsp .gitignore file.: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
    "--skip=crates::api::tests::get_common_crates"
    "--skip=crates::sparse::tests::get_common_crates"
  ];

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
