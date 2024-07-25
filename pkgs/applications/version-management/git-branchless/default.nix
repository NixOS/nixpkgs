{ lib
, fetchFromGitHub
, fetchpatch
, git
, libiconv
, ncurses
, openssl
, pkg-config
, rustPlatform
, sqlite
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    hash = "sha256-ev56NzrEF7xm3WmR2a0pHPs69Lvmb4He7+kIBYiJjKY=";
  };

  patches = [
    # Fix tests with Git 2.44.0+
    (fetchpatch {
      name = "1245.patch"; # https://github.com/arxanas/git-branchless/pull/1245
      url = "https://github.com/arxanas/git-branchless/commit/c8436aed3d616409b4d6fb1eedb383077f435497.patch";
      hash = "sha256-gBm0A478Uhg9IQVLQppvIeTa8s1yHUMddxiUbpHUvGw=";
    })
    # Fix tests with Git 2.44.0+
    (fetchpatch {
      name = "1161.patch"; # https://github.com/arxanas/git-branchless/pull/1161
      url = "https://github.com/arxanas/git-branchless/commit/6e1f26900a0dd60d10d9aa3552cab9181fa7be03.patch";
      hash = "sha256-KHobEIXhlDar8CvIVUi4I695jcJZXgGRhU86b99x86Y=";
    })
  ];

  cargoHash = "sha256-Ppw5TN/6zMNxFAx90Q9hQ7RdGxV+TT8UlOm68ldK8oc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    ncurses
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ nh2 hmenke ];
  };
}
