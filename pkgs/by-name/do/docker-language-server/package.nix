{
  lib,
  fetchFromGitHub,
  buildGoModule,
  docker,
  gotestsum,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "docker-language-server";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "docker";
    repo = "docker-language-server";
    tag = "v${finalAttrs.version}";
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

    gotestsum -- $packages \
      -timeout 30s \
      -skip "TestCollectDiagnostics|TestCompletion_ImageTags|TestInlayHint"

    go test ./e2e-tests/... \
      -timeout 120s \
      -skip "TestPublishDiagnostics|TestHover"

    runHook postCheck
  '';

  ldflags = [
    "-s"
    "-X 'github.com/docker/docker-language-server/internal/pkg/cli/metadata.Version=${finalAttrs.version}'"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Language server for providing language features for file types in the Docker ecosystem (Dockerfiles, Compose files, and Bake files)";
    homepage = "https://github.com/docker/docker-language-server";
    changelog = "https://github.com/docker/docker-language-server/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    mainProgram = "docker-language-server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ baongoc124 ];
  };
})
