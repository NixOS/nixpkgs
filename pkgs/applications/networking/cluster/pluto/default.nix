{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.15.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    sha256 = "sha256-qCWKmn0buITZo86hQncXWuEDQq0rITrCz/aRVR1+Zt4=";
  };

  vendorHash = "sha256-3wtE2Cz+AVF+zfsLH/+6KMHPihYcuYsrzTguHNnwT+U=";

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
