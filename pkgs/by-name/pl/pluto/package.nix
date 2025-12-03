{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pluto";
  version = "5.22.6";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-6Xi+EWQvFYtdiVywhSB4Lmzsc6Z1nE8UWO8vBteVOnE=";
  };

  vendorHash = "sha256-59mRVfQ2rduTvIJE1l/j3K+PY3OEMfNpjjYg3hqNUhs=";

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
      kashw2
    ];
  };
}
