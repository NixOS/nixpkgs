{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.22.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
    hash = "sha256-tvvTaRPOmNX0D8QvgA+8u5XsMxnT9PK4PMBcL6RHSIE=";
  };

  vendorHash = "sha256-T6ZeQKrdz16zwppkFei21JjwGsoPLHazHTZew822xdU=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
    mainProgram = "lego";
  };

  passthru.tests.lego = nixosTests.acme;
}
