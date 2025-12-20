{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule rec {
  pname = "lego";
  version = "4.29.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${version}";
    hash = "sha256-czCOrgC3Xy42KigAe+tsPRdWqxgdHFl0KN3Ei2zeyy8=";
  };

  vendorHash = "sha256-OnCtobizqDrqZTQenRPBTlUHvNx/xX34PYw8K4rgxSk=";

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
