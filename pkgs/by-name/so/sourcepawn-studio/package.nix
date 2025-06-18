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
  version = "8.1.3";

  src = fetchFromGitHub {
    owner = "Sarrus1";
    repo = "sourcepawn-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qeKaIYI9+t9D/6/SSoJrnkA6DX6Wv/51vZCJIHm/0ts=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8/HTrniZhXT68Ni9zjze8/mDu0TrMJKw41EEWPOhKjw=";

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
