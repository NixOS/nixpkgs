{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pluto";
  version = "5.19.4";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-PhP3ILOYv+7gmxOJLCgIYp+1FIJirZo7TZJoZv8A1WM=";
  };

  vendorHash = "sha256-EVlYhlEXwgUfRaxAJ3dBTz6MJ2QITZtnHVcQQN1cHbk=";

  ldflags = [
    "-w" "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    mainProgram = "pluto";
    license = licenses.asl20;
    maintainers = with maintainers; [ peterromfeldhk kashw2 ];
  };
}
