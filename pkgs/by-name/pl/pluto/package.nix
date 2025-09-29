{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pluto";
  version = "5.22.5";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "pluto";
    rev = "v${version}";
    hash = "sha256-MserKZcOkif56XeTLRzHDDk6HYeVhgKsnOjsfv0vPeQ=";
  };

  vendorHash = "sha256-59mRVfQ2rduTvIJE1l/j3K+PY3OEMfNpjjYg3hqNUhs=";

  ldflags = [
    "-w"
    "-s"
    "-X main.version=v${version}"
  ];

  __darwinAllowLocalNetworking = true; # for tests

  meta = {
    homepage = "https://github.com/FairwindsOps/pluto";
    description = "Find deprecated Kubernetes apiVersions";
    mainProgram = "pluto";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      peterromfeldhk
      kashw2
    ];
  };
}
