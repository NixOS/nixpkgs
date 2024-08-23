{
  lib,
  fetchFromGitHub,
  git,
  libiconv,
  ncurses,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-4RRSffkAe0/8k4SNnlB1iiaW4gWFTuYXplVBj2aRIdU=";
  };

  cargoHash = "sha256-Jg4d7tJXr2O1sEDdB/zk+7TPBZvgHlmW8mNiXozLKV8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      ncurses
      openssl
      sqlite
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
      libiconv
    ];

  postInstall = ''
    $out/bin/git-branchless install-man-pages $out/share/man
  '';

  preCheck = ''
    export TEST_GIT=${git}/bin/git
    export TEST_GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';
  # FIXME: these tests deadlock when run in the Nix sandbox
  checkFlags = [
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
    ];
  };
}
