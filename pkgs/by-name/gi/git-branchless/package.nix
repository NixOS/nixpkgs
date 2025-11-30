{
  lib,
  fetchFromGitHub,
  git,
  ncurses,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-8uv+sZRr06K42hmxgjrKk6FDEngUhN/9epixRYKwE3U=";
  };

  # Patch the vendored esl01-indexedlog crate.
  # This is necessary to fix the build for rust 1.89. See:
  # - https://github.com/NixOS/nixpkgs/issues/437051
  # - https://github.com/arxanas/git-branchless/issues/1585
  # - https://github.com/facebook/sapling/issues/1119
  # The patch is derived from:
  # - https://github.com/facebook/sapling/commit/9e27acb84605079bf4e305afb637a4d6801831ac
  postPatch = ''
    (
      cd ../git-branchless-*-vendor/esl01-indexedlog-*/
      patch -p1 < ${./fix-esl01-indexedlog-for-rust-1_89.patch}
    )
  '';

  cargoHash = "sha256-i7KpTd4fX3PrhDjj3R9u98rdI0uHkpQCxSmEF+Gu7yk=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
    sqlite
  ];

  postInstall = lib.optionalString (with stdenv; buildPlatform.canExecute hostPlatform) ''
    $out/bin/git-branchless install-man-pages $out/share/man
  '';

  preCheck = ''
    export TEST_GIT=${git}/bin/git
    export TEST_GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';

  # Note that upstream has disabled CI tests for git>=2.46
  # See: https://github.com/arxanas/git-branchless/issues/1416
  #      https://github.com/arxanas/git-branchless/pull/1417
  # To be re-enabled once arxanas/git-branchless#1416 is resolved
  doCheck = false;

  checkFlags = [
    # FIXME: these tests deadlock when run in the Nix sandbox
    "--skip=test_switch_pty"
    "--skip=test_next_ambiguous_interactive"
    "--skip=test_switch_auto_switch_interactive"
  ];

  meta = with lib; {
    description = "Suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    mainProgram = "git-branchless";
    maintainers = with maintainers; [
      nh2
      hmenke
      bryango
    ];
  };
}
