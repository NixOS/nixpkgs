{ fetchFromGitHub, buildGoModule, lib, testers, gitmux }:

buildGoModule rec {
  pname = "gitmux";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "arl";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-0WfxtOidHiRxSXGzG8So965f/sBS0DY7fEDsocvfPiY=";
  };

  vendorHash = "sha256-talZSkf8lQXwXKdkQliHFv2K+42BFtcg13oB5Szkff0=";

  # GitHub source does contain a regression test for the module
  # but it requires networking as it git clones a repo from github
  doCheck = false;

  ldflags = [ "-X main.version=${version}" ];

  passthru.tests.version = testers.testVersion {
    package = gitmux;
    command = "gitmux -V";
  };

  subPackages = [ "." ];

  meta = with lib; {
    description = "Git in your tmux status bar";
    homepage = "https://github.com/arl/gitmux";
    license = licenses.mit;
    maintainers = with maintainers; [ nialov ];
  };
}
