{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "lego";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = "lego";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zCZmP7Rx2wgwy/VyZ3hNLSxc8iRtijJJ+UasiNIo/HY=";
  };

  vendorHash = "sha256-ffaPAl01gDA9MbxyD9SJXb5O07R4iEsY6aZUWEDQKGs=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
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
})
