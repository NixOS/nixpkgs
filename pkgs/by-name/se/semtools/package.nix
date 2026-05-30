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
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "run-llama";
    repo = "semtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vQJd1/EnskcMNN2cfXOQxHeLPh61dypL51KwCLps8Q=";
  };

  cargoHash = "sha256-spllUpCze3ajNZtWVRr9GZLDj7HMi6UIraeEp9XgfK0=";

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
