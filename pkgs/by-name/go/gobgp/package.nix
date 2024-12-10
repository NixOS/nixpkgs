{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gobgp";
  version = "3.30.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-UB3LYXRr6GnqVCRwAxnwqBCkOtor3mC4k73kPesZs0g=";
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

  subPackages = [ "cmd/gobgp" ];

  meta = with lib; {
    description = "CLI tool for GoBGP";
    homepage = "https://osrg.github.io/gobgp/";
    license = licenses.asl20;
    maintainers = with maintainers; [ higebu ];
    mainProgram = "gobgp";
  };
}
