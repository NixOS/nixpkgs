{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ssmsh,
}:

buildGoModule rec {
  pname = "ssmsh";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "bwhaley";
    repo = "ssmsh";
    rev = "v${version}";
    sha256 = "sha256-UmfwDukRVyfX+DmUfRi+KepqFrPtDNImKd22/dI7ytk=";
  };

  vendorHash = "sha256-+7duWRe/haBOZbe18sr2qwg419ieEZwYDb0L3IPLA4A=";

  doCheck = true;

  ldflags = [
    "-w"
    "-s"
    "-X main.Version=${version}"
  ];

  passthru.tests = testers.testVersion {
    package = ssmsh;
    command = "ssmsh -version";
    version = "Version ${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/bwhaley/ssmsh";
    description = "Interactive shell for AWS Parameter Store";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
    mainProgram = "ssmsh";
  };
}
