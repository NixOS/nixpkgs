{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dependi-lsp";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "mpiton";
    repo = "zed-dependi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqkCgyfyEi83fuJGblOyQHTKsed+44Pa2EzlqaHOHi8=";
  };

  cargoRoot = "dependi-lsp";
  buildAndTestSubdir = "dependi-lsp";
  cargoHash = "sha256-G1CdEZwDb75UHOflUJvyynyF31Nhl5kVHsxNZCarAPA=";

  cargoBuildFlags = [
    "--bin"
    "dependi-lsp"
  ];

  # Integration tests require network access.
  doCheck = false;

  meta = {
    description = "LSP backend for the Dependi extension in Zed Editor";
    homepage = "https://mpiton.github.io/zed-dependi";
    changelog = "https://github.com/mpiton/zed-dependi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "dependi-lsp";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ xBLACKICEx ];
  };
})
