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
  version = "0.3.6-nixos.0";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    sha256 = "sha256-Sq+43w7xgrCe2w+9A/gfe/34+K2IgZVholtD+WF59Qo=";
  };

  cargoSha256 = "sha256-tCpvIqGMklOUJ/+d8poq4uz2EyZTkBmtlkA/BUIVPxs=";

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
    export PATH_TO_GIT=${git}/bin/git
    export GIT_EXEC_PATH=$(${git}/bin/git --exec-path)
  '';

  meta = with lib; {
    description = "A suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ msfjarvis nh2 hmenke ];
  };
}
