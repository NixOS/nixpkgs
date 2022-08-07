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
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    sha256 = "sha256-1bUHltONLfJumkxPnzGJFMMyS02LVqjpDL+KgiewyoQ=";
  };

  cargoSha256 = "sha256-3+ULHqtKAhf4AdoLPK/3IqnfOcskoh6ctlQnY1oTHJ8=";

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

  preCheck = ''
    export TEST_GIT=${git}/bin/git
    export TEST_GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';
  # FIXME: these tests deadlock when run in the Nix sandbox
  checkFlags = [
    "--skip=test_checkout_pty"
    "--skip=test_next_ambiguous_interactive"
  ];

  # Fixed in next release
  patches = [
    (fetchpatch {
      url = "https://github.com/arxanas/git-branchless/commit/8bed1e83495a448f479103d2d4b75745aa512667.patch";
      sha256 = "sha256-bFfXBYxfgx1TxlJ+/2Gh9WsgL2vCJKwwbq4JD8/2c1w=";
      name = "fix-tests-for-latest-git";
    })
  ];

  meta = with lib; {
    description = "A suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ msfjarvis nh2 hmenke ];
  };
}
