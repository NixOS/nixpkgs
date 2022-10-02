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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    sha256 = "sha256-jAc17poNTld3eptN1Vd1MOKS5iloMWkq3oZgpWBkGTY=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "build-run-cargo-update";
      url = "https://github.com/arxanas/git-branchless/commit/0ac3f325520f79d15368aa9d14893ebc17313ab6.patch";
      sha256 = "sha256-S1kazUzvz3FzFpphSRhWiv/l2b/+zC9HtAl7ndq5aJA=";
    })
  ];

  cargoSha256 = "sha256-Lo/Q6OSIzWrRNiTGsOWRX+6FEcj4fk1kn7V9tw67UVo=";

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
