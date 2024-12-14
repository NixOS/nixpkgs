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

  cargoHash = "sha256-AEEAHMKGVYcijA+Oget+maDZwsk/RGPhHQfiv+AT4v8=";

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
