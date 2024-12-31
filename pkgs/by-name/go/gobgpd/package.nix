{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.32.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "refs/tags/v${version}";
    hash = "sha256-DIOii1jFVK3jwDLaLFWBbbQPC9eQnTwLYwI8uC8G8ig=";
  };

  vendorHash = "sha256-FYLH1Ej8Bm0+tS5Ikj1CPF+1t5opmzee8iHRZSW94Yk=";

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  ldflags = [
    "-s"
    "-w"
    "-extldflags '-static'"
  ];

  subPackages = [
    "cmd/gobgpd"
  ];

  passthru.tests = { inherit (nixosTests) gobgpd; };

  meta = with lib; {
    description = "BGP implemented in Go";
    mainProgram = "gobgpd";
    homepage = "https://osrg.github.io/gobgp/";
    changelog = "https://github.com/osrg/gobgp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
  };
}
