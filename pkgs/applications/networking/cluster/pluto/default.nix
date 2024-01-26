{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.19.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-6TOHDjR5sFaIeR6Zuf4azQAIgUyev7vdlAKB7YNk8R0=";
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
