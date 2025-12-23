{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "lego";
  version = "4.30.1";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
    hash = "sha256-v6Dx/tuD+a7BEPePzYIV3pE6Ek36ndUqXmCSdUiw/v8=";
  };

  vendorHash = "sha256-qODY5VZgzZWCnwqEY7PLyuO2gNvQ1N/EtRneu5PM3lo=";

  doCheck = false;

  subPackages = [ "cmd/lego" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = {
    description = "Let's Encrypt client and ACME library written in Go";
    license = lib.licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    teams = [ lib.teams.acme ];
    mainProgram = "lego";
  };

  passthru.tests = {
    lego-http = nixosTests.acme.http01-builtin;
    lego-dns = nixosTests.acme.dns01;
  };
}
