{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "gobgp";
  version = "3.36.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    rev = "v${version}";
    sha256 = "sha256-vyMC3FcfMHVsRosLkTYgCawiTIcJs0R5GgSZERRPHnE=";
  };

  vendorHash = "sha256-bR6msi2IyNmYgmpLrbn/hnX4EzLOBa2UHTzwDJFasos=";

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
