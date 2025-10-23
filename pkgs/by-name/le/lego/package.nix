{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "lego";
  version = "4.26.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
    hash = "sha256-wSTymGprdoXxBRlGDapF5H8SMbBRTI24PMgakGetABI=";
  };

  vendorHash = "sha256-BdOS4BNWtonLoZO4YA85VdB6MRbMqoO8MGb4XNEwfCk=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    teams = [ teams.acme ];
    mainProgram = "lego";
  };

  passthru.tests = {
    lego-http = nixosTests.acme.http01-builtin;
    lego-dns = nixosTests.acme.dns01;
  };
}
