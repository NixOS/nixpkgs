{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  rustfmt,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-glancer";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rust-glancer";
    repo = "rust-glancer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3CdKyRsKbMfPBZ2UXgRmj+sKhQMl5GRuT7Pc2VkJpzs=";
  };

  cargoHash = "sha256-88gs9H8HgK8n/Qx2nncJQ/FQEiSmk+7HK8iCxzM+1bA=";

  cargoBuildFlags = [
    "--bin"
    "rust-glancer"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  # Upstream runs the workspace test suite through cargo-nextest (see Justfile).
  useNextest = true;
  doCheck = true;
  nativeCheckInputs = [
    rustfmt
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight Rust LSP that trades incompleteness for performance and low memory usage";
    homepage = "https://rust-glancer.github.io/";
    downloadPage = "https://github.com/rust-glancer/rust-glancer";
    changelog = "https://github.com/rust-glancer/rust-glancer/blob/v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = [ lib.maintainers.philocalyst ];
    mainProgram = "rust-glancer";
    platforms = lib.platforms.unix;
  };
})
