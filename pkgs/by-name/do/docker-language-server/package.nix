{
  lib,
  fetchFromGitHub,
  buildGoModule,
  docker,
  gotestsum,
}:

buildGoModule rec {
  pname = "docker-language-server";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker-language-server";
    tag = "v${version}";
    hash = "sha256-d3lGCIssrQqZNYyQ0RlXfjp1/z5tNtNTy6LkCC77qpA=";
  };

  vendorHash = "sha256-6wngmwVtHSTPfsJQJ+swGM9H+yCbXDPLGCcTys1Zb4A=";

  nativeCheckInputs = [
    docker
    gotestsum
  ];

  checkPhase = ''
    runHook preCheck
    gotestsum -- $(go list ./... | grep -vE "e2e-tests|/buildkit$|/scout$") -timeout 30s -skip "TestCollectDiagnostics"
    go test $(go list ./... | grep e2e-tests) -timeout 120s -skip "TestPublishDiagnostics|TestHover"
    runHook postCheck
  '';

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/docker/docker-language-server/internal/pkg/cli/metadata.Version=${version}'"
  ];

  meta = with lib; {
    homepage = "https://github.com/docker/docker-language-server";
    description = "Language server for providing language features for file types in the Docker ecosystem (Dockerfiles, Compose files, and Bake files)";
    mainProgram = "docker-language-server";
    license = licenses.asl20;
    maintainers = with maintainers; [ baongoc124 ];
  };
}
