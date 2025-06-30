{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-appraiser";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "washanhanzi";
    repo = "cargo-appraiser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YbrswdLNrd+p4NHLyt1OKfAO270N+Wi3ANiAZHg2zjE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hmgpI1kGi6E7Lka3puTnhyMdXY4FR152M2lnyVyBtMU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  checkFlags = [
    # uses hardcoded absolute filepath that does not exist
    "--skip=controller::audit::tests::test_audit_workspace"
    # uses hardcoded absolute windows filepath
    "--skip=usecase::document::tests::test_parse"
  ];

  meta = {
    description = "LSP server for Cargo.toml files";
    mainProgram = "cargo-appraiser";
    homepage = "https://github.com/washanhanzi/cargo-appraiser";
    changelog = "https://github.com/washanhanzi/cargo-appraiser/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ timon ];
  };
})
