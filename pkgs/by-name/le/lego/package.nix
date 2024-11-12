{ lib, fetchFromGitHub, buildGoModule, nixosTests }:

buildGoModule rec {
  pname = "lego";
  version = "4.20.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5qqshbxdsOR65zeUo1ebF+c+nbbgXD/8dvR9zqJsJcI=";
  };

  vendorHash = "sha256-AfCY86Kn0pO2Uq93rCH513dDdcbyfD08/KNRFL7dFes=";

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
