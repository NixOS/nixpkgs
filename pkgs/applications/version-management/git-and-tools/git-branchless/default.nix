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
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    sha256 = "sha256-TLqAU1/olSS59Zeb+2m9Jq19EYTO1TnbKPYciHPKO2A=";
  };

  cargoSha256 = "sha256-sA4KWGW4bxGUkotTWHUcRqcoaUJsSUCTK8hUkKiRcnY=";

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

  meta = with lib; {
    description = "A suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ msfjarvis nh2 hmenke ];
  };
}
