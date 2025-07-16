{
  lib,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-statuses";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "bircni";
    repo = "git-statuses";
    tag = finalAttrs.version;
    hash = "sha256-pnqg32FH26NTtt7N5db/JGjjR3MbPOFPtMA2iZNFiSI=";
  };

  patches = [
    # This commit requires Rust 1.88, which is not yet in Nixpkgs.
    (fetchpatch {
      url = "https://github.com/bircni/git-statuses/commit/8bc32d1bd47d2a9e48f1408a9137213bae925912.patch";
      hash = "sha256-JNWsv0DjwrSbMu/j2+XMoZKgvB1OgUA3b2BNuZTM/cA=";
      revert = true;
    })
  ];

  # fix tests, ref. https://github.com/bircni/git-statuses/pull/8
  postPatch = ''
    substituteInPlace src/tests/gitinfo_test.rs --replace-fail \
      'let repo = git2::Repository::init(tmp_dir.path()).unwrap();' \
      'let repo = git2::Repository::init(tmp_dir.path()).unwrap();
       let mut config = repo.config().unwrap();
       config.set_str("user.name", "Test User").unwrap();
       config.set_str("user.email", "test@example.com").unwrap();'
  '';

  cargoHash = "sha256-thLyIxuAACtexqCddKWuUE8Vl0CeUEBP7XxDPYT23lg=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    openssl
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool to display the status of multiple Git repositories in a clear, tabular format";
    homepage = "https://github.com/bircni/git-statuses";
    changelog = "https://github.com/bircni/git-statuses/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "git-statuses";
  };
})
