{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.10.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    sha256 = "sha256-Pdw8xPpH9PjLDbno8u3IWI7ygO18j2P3puE55+Pmzec=";
  };

  vendorSha256 = "sha256-hAnlKMDqrQG8vlmBLufJlq79rb1vo4PdVaJjBBSjnRM=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk ];
  };
}
