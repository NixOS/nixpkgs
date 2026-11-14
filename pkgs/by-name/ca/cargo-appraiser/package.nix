{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-appraiser";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "washanhanzi";
    repo = "cargo-appraiser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XNh+mHom+XpGq8Pz/PZgIXL6f/MHHSlTDzeJbRfgVVY=";
  };

  cargoHash = "sha256-1p79uBDSgKJs2Ttws7evkr/amnQJ/gaeEX1NUNBhrnE=";

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
