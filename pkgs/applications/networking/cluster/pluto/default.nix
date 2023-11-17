{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.18.6";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-PQf1gEFlZ6Y9KMQjKeXAZy/OfxCbiKfST3pr9xp0/vg=";
  };

  vendorHash = "sha256-8ZOYp/vM16PugmE+3QK7ZRDwIwRCMEwD0NRyiOBlh14=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk kashw2 ];
  };
}
