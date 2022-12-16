{ lib, buildGoModule, fetchFromGitHub, testers, git-sizer }:

buildGoModule rec {
  pname = "git-sizer";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-On7QBTzKfnuuzwMQ8m1odxGqfIKL+EDg5V05Kxuhmqw=";
  };

  vendorSha256 = "sha256-oRlsD99XiI/0ZWibjyRcycmGab+vMbXrV5hIdIyUDYg=";

  ldflags = [ "-s" "-w" "-X main.BuildVersion=${version}" ];

  doCheck = false;

  passthru.tests.vesion = testers.testVersion {
    package = git-sizer;
  };

  meta = with lib; {
    description = "Compute various size metrics for a Git repository";
    homepage = "https://github.com/github/git-sizer";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewbauer ];
  };
}
