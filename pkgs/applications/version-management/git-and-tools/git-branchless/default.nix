{ lib, fetchFromGitHub

, coreutils
, git
, libiconv
, ncurses
, rustPlatform
, sqlite
, stdenv
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-branchless";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "arxanas";
    repo = "git-branchless";
    rev = "v${version}";
    sha256 = "0pfiyb23ah1h6risrhjr8ky7b1k1f3yfc3z70s92q3czdlrk6k07";
  };

  cargoSha256 = "0gplx80xhpz8kwry7l4nv4rlj9z02jg0sgb6zy1y3vd9s2j5wals";

  # Remove path hardcodes patching if they get fixed upstream, see:
  # https://github.com/arxanas/git-branchless/issues/26
  postPatch = ''
    # Inline test hardcodes `echo` location.
    substituteInPlace ./src/commands/wrap.rs --replace '/bin/echo' '${coreutils}/bin/echo'

    # Tests in general hardcode `git` location.
    substituteInPlace ./src/testing.rs --replace '/usr/bin/git' '${git}/bin/git'
  '';

  buildInputs = [
    ncurses
    sqlite
  ] ++ lib.optionals (stdenv.isDarwin) [
    Security
    SystemConfiguration
    libiconv
  ];

  preCheck = ''
    # Tests require path to git.
    export PATH_TO_GIT=${git}/bin/git
  '';

  meta = with lib; {
    description = "A suite of tools to help you visualize, navigate, manipulate, and repair your commit history";
    homepage = "https://github.com/arxanas/git-branchless";
    license = licenses.asl20;
    maintainers = with maintainers; [ msfjarvis nh2 ];
  };
}
