{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fq,
  testers,
}:

buildGoModule rec {
  pname = "fq";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "wader";
    repo = "fq";
    rev = "v${version}";
    hash = "sha256-I3mVAPNWjRHG0td1ulzGOthiNybfWLx1HgwPjFfBHCo=";
  };

  vendorHash = "sha256-p2cvv983gYTvyLPYIGVsk6N7yUzBpiPzgJ3sMRNWPTo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  subPackages = [ "." ];

  passthru.tests = testers.testVersion { package = fq; };

  meta = with lib; {
    description = "jq for binary formats";
    mainProgram = "fq";
    homepage = "https://github.com/wader/fq";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
