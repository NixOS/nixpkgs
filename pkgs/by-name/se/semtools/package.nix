{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "semtools";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "semtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1fPmhggUUiDAvAn57NwFdSLb3hpJbURH5f4HOfKa5Pw=";
  };

  cargoHash = "sha256-3dn4Ax9QNrQ0OyogR3yb+rPydZP9c4sK4eIrTTulRJE=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ openssl ];

  checkFlags = [
    # Require network
    "--skip=search::tests"
    "--skip=workspace::tests::test_workspace_save_and_open"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic search and document parsing tools for the command line";
    homepage = "https://github.com/run-llama/semtools";
    changelog = "https://github.com/run-llama/semtools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
})
