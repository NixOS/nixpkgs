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
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "crate-ci";
    repo = "cargo-release";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w+7kvJQBlb40W+vRAXmySOaL513501fj25PkWI8lQTw=";
  };

  cargoHash = "sha256-rU8HQBrK/0aRCz5hvUQCMxRCbP2N98S+0gvVNqkap7s=";

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

  checkFlags = [
    # Skip tests that require internet connection
    "--skip=publish::unpublished_git_dependency"
    "--skip=publish::unpublished_workspace_dependency"
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
