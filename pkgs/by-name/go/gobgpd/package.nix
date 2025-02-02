{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.34.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    tag = "v${version}";
    hash = "sha256-g5ql5SFggnA6TsfoXlKfOZ1P1XqNqKDFE5aaDt9vsVg=";
  };

  vendorHash = "sha256-NFKorYDHhbohxWMshEm1JswHPcrNRajc1MCI5eQvtQU=";

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
