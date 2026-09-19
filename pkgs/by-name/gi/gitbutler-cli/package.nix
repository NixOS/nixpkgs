{
  lib,
  cmake,
  dbus,
  fetchFromGitHub,
  git,
  libgit2,
  makeWrapper,
  nix-update-script,
  openssl,
  perl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler-cli";
  version = "0.19.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-ppl1noikPwTvG/XT7iYG41+9ZZO8i0x2L+odeEzRP1s=";
  };

  cargoHash = "sha256-xW/eO+AQQUBN2MrixNx3LKhwMookkKuX5LF4DSWQKKY=";

  # `but` needs `gitbutler-git-askpass` and `gitbutler-git-setsid` for push/fetch operations
  cargoBuildFlags = [
    "--package=but"
    "--package=gitbutler-git"
  ];

  cargoTestFlags = [
    "--package"
    "but"
    "--"
    # TUI tests require filesystem/git access unavailable in the sandbox
    "--skip=command::legacy::status::tui::tests"
    # Archive at 'tests/fixtures/generated-archives/[...].tar' not found [..] Error: No such file or directory (os error 2)
    "--skip=merge_first_branch_into_gb_local_and_verify_rebase"
    "--skip=json_output_with_dangling_commits"
    "--skip=two_dangling_commits_different_branches"
  ];

  buildFeatures = [
    "packaged-but-distribution"
  ];

  # cargo-auditable fails because `but-db` uses `dep:tokio`
  auditable = false;

  nativeBuildInputs = [
    cmake # Required by `aws-lc-sys` crate
    makeWrapper
    perl # Required by `aws-lc-sys` crate
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux dbus; # Required by `libdbus-sys` via `keyring` crate

  nativeCheckInputs = [ git ];

  # Place helper binaries alongside `but` so it can find them at runtime
  postInstall = ''
    mkdir -p $out/libexec/gitbutler-cli
    mv $out/bin/but $out/libexec/gitbutler-cli/but
    mv $out/bin/gitbutler-git-askpass $out/libexec/gitbutler-cli/gitbutler-git-askpass
    mv $out/bin/gitbutler-git-setsid $out/libexec/gitbutler-cli/gitbutler-git-setsid
    makeWrapper $out/libexec/gitbutler-cli/but $out/bin/but
  '';

  env = {
    # task tracing requires Tokio to be built with RUSTFLAGS="--cfg tokio_unstable"
    RUSTFLAGS = "--cfg tokio_unstable";

    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = 1;
  };

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release/(.*)"
      ];
    };
  };

  meta = {
    description = "Git CLI client `but` for simultaneous branches on top of your existing workflow";
    homepage = "https://gitbutler.com";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      ejiektpobehuk
      getchoo
      techknowlogick
    ];
    mainProgram = "but";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
