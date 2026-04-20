{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  curl,
  git,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-release";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xil5k+AyJHpDLVvSbtPJOuADRXvdLrHLlC7GRSE4z4s=";
  };

  cargoHash = "sha256-WLDRJQvzkL1FxD0eXsJmH5wh9QkReaQBBxe7ZFQMWUM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  nativeCheckInputs = [
    git
  ];

  # disable vendored-libgit2 and vendored-openssl
  buildNoDefaultFeatures = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''Cargo subcommand "release": everything about releasing a rust crate'';
    mainProgram = "cargo-release";
    homepage = "https://github.com/crate-ci/cargo-release";
    changelog = "https://github.com/crate-ci/cargo-release/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      gerschtli
      progrm_jarvis
    ];
  };
})
