{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "gobgpd";
  version = "3.36.0";

  src = fetchFromGitHub {
    owner = "osrg";
    repo = "gobgp";
    tag = "v${version}";
    hash = "sha256-vyMC3FcfMHVsRosLkTYgCawiTIcJs0R5GgSZERRPHnE=";
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
