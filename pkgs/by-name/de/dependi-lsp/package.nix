{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dependi-lsp";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "mpiton";
    repo = "zed-dependi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pqkCgyfyEi83fuJGblOyQHTKsed+44Pa2EzlqaHOHi8=";
  };

  cargoRoot = "dependi-lsp";
  buildAndTestSubdir = "dependi-lsp";
  cargoHash = "sha256-G1CdEZwDb75UHOflUJvyynyF31Nhl5kVHsxNZCarAPA=";

  nativeBuildInputs = [
    pkg-config
  ];

  cargoBuildFlags = [
    "--bin"
    "dependi-lsp"
  ];

  # Integration tests require network access.
  doCheck = false;

  meta = with lib; {
    description = "Language server for dependency management in Zed";
    homepage = "https://github.com/mpiton/zed-dependi";
    changelog = "https://github.com/mpiton/zed-dependi/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    mainProgram = "dependi-lsp";
    platforms = platforms.unix;

    maintainers = [ ];
  };
})
