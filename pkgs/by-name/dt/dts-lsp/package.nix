{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage ({
  pname = "dts-lsp";
  version = "0.1.5-unstable-2025-03-24";

  src = fetchFromGitHub {
    owner = "igor-prusov";
    repo = "dts-lsp";
    rev = "e43331e09a4a2e6a8f770194cce2f4bb58507f1a";
    hash = "sha256-qoUzkV+RpT+unROz8IZHDwrRDePU1JXfbRusfi9b+ys=";
  };

  cargoHash = "sha256-NWmdGmM0cdvhscPxjYlIJKgf9towHh+BfY8cuGbS3MA=";

  meta = {
    description = "LSP for DTS files built on top of tree-sitter-devicetree grammar";
    homepage = "https://github.com/igor-prusov/dts-lsp";
    license = lib.licenses.mit;
    mainProgram = "dts-lsp";
    maintainers = with lib.maintainers; [ filippo-biondi ];
    platforms = with lib.platforms; darwin ++ linux;
  };
})
