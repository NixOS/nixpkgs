{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.19.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-O4lzOZUiicmahxcbzPsEU2+tPDTCUun2JLeWZjpTZIQ=";
  };

  vendorHash = "sha256-BcE/8pxQdJp9vttLo4wDSUswJnaBhIn/mlt3ZcOf2wA=";

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
