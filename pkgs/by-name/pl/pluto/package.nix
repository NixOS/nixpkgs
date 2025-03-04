{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pluto";
  version = "5.21.3";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-/gq6BdlNG9vUazVt7Ucvv2679BytUEZrx6u8znnsxG4=";
  };

  vendorHash = "sha256-PABCma+pfguDHxRhvQYCHcjr7Epy2AteC+QiXbAx04k=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    mainProgram = "pluto";
    license = licenses.asl20;
    maintainers = with maintainers; [
      peterromfeldhk
      kashw2
    ];
  };
}
