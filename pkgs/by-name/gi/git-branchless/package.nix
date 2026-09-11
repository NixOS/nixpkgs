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
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-branchless";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${finalAttrs.version}";
    hash = "sha256-V769kYbmUe6JtVoo83ejxUsegyiBh07tMYPVhJiFNgs=";
  };

  cargoHash = "sha256-5uygCOzPNqHjKJfq2LFTfaRT/N++/AY/PwlBJ8j8QwM=";

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    mainProgram = "git-branchless";
    maintainers = with lib.maintainers; [
      nh2
      hmenke
      bryango
    ];
  };
})
