{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pluto";
  version = "5.21.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-BGfTgL5xAudgGAyINVq9eyyUHRb6iZ/eEO5qxUl5cI0=";
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
