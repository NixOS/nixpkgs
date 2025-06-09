{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sourcepawn-studio";
  version = "8.1.2";

  src = fetchFromGitHub {
    owner = "Sarrus1";
    repo = "sourcepawn-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L/xgzWbhfRTvoRElKApb9JKXNfqJF+nfDk9Xo/qwL00=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5Zd3Stoi8AqsZE38pnilmjuRMgTPAGB+R8QI2JFZ7s4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlags = [
    # requires rustup and rustfmt
    "--skip tests::sourcegen::generate_node_kinds"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "sourcepawn-studio";
    description = "LSP implementation for the SourcePawn programming language written in Rust";
    homepage = "https://sarrus1.github.io/sourcepawn-studio/";
    changelog = "https://github.com/Sarrus1/sourcepawn-studio/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.awwpotato ];
  };
})
