{
  lib,
  fetchFromGitHub,
  buildGoModule,
  docker,
  gotestsum,
}:

buildGoModule rec {
  pname = "docker-language-server";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker-language-server";
    tag = "v${version}";
    hash = "sha256-OSAySCTK2temrVxmkRnrl5YWVbmkp8DRlXFVxTzEW3Q=";
  };

  vendorHash = "sha256-ztA+/4l180UKTKrsqTyysDcD4oQSDgnBYUaiKDF6LvI=";

  nativeCheckInputs = [
    docker
    gotestsum
  ];

  checkPhase = ''
    runHook preCheck

    # disable some tests because of sandbox
    excludedPackages="e2e-tests|/buildkit$|/scout$"
    packages=$(go list ./... | grep -vE "$excludedPackages")
    gotestsum -- $packages -timeout 30s -skip "TestCollectDiagnostics|TestCompletion_ImageTags|TestInlayHint"
    go test ./e2e-tests/... -timeout 120s -skip "TestPublishDiagnostics|TestHover"

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
