{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-appraiser";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "washanhanzi";
    repo = "cargo-appraiser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5n/HN9vrEqQcvTa19KhoF8EvS7HhO9Q3smMUcauI+n4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-+Mb1sSxaSoF/LNJo/Myb+ZYgpzhe8ltKMJ41KTlXLuQ=";

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
