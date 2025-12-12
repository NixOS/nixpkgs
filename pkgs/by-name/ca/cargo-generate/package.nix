{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  coreutils,
  gitMinimal,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-generate";
  version = "0.23.5";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h6WsTXPlJYoMZ6QDR99LQr5uV0ij8NC02ZEVhg/U+qc=";
  };

  postPatch = ''
    substituteInPlace src/hooks/system_mod.rs \
      --replace-fail "/bin/cat" "${lib.getExe' coreutils "cat"}"
  '';

  cargoHash = "sha256-pZm7bsMIOQF/wSwFH5kFXN5mG/H1cKz5hyM2DeNmUQ8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
  ];

  nativeCheckInputs = [ gitMinimal ];

  # disable vendored libgit2 and openssl
  buildNoDefaultFeatures = true;

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  # Exclude some tests that don't work in sandbox:
  # - favorites_default_to_git_if_not_defined: requires network access to github.com
  # - should_canonicalize: the test assumes that it will be called from the /Users/<project_dir>/ folder on darwin variant.
  checkFlags = [
    "--skip=favorites::favorites_default_to_git_if_not_defined"
    "--skip=git_instead_of::should_read_the_instead_of_config_and_rewrite_an_git_at_url_to_https"
    "--skip=git_instead_of::should_read_the_instead_of_config_and_rewrite_an_ssh_url_to_https"
    "--skip=git_over_ssh::it_should_retrieve_the_private_key_from_ssh_agent"
    "--skip=git_over_ssh::it_should_support_a_public_repo"
    "--skip=git_over_ssh::it_should_use_a_ssh_key_provided_by_identity_argument"
    # stderr doesn't quite match what is expected, slightly malformed test
    # source
    "--skip=hooks_and_rhai::it_fails_when_a_system_command_returns_non_zero_exit_code"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=git::utils::should_canonicalize"
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = {
    description = "Tool to generate a new Rust project by leveraging a pre-existing git repository as a template";
    mainProgram = "cargo-generate";
    homepage = "https://github.com/cargo-generate/cargo-generate";
    changelog = "https://github.com/cargo-generate/cargo-generate/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      turbomack
      matthiasbeyer
    ];
  };
})
