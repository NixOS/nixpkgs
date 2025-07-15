{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pluto";
  version = "5.21.8";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-41ud7SRaivhmtBY6ekKIpRijTuLqJ/tLi0dTHDsGAps=";
  };

  vendorHash = "sha256-4kiLgwr8wr/L4anxgZVAE6IFdbBvTgcUlf5KIcT+lRk=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  __darwinAllowLocalNetworking = true; # for tests

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
