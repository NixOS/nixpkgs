{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  go-task,
  gotestsum,
}:

buildGoModule (finalAttrs: {
  pname = "go-mockery";
  version = "3.5.5";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-paoI7KkpLbpQyEwS/oW8Ck9KiJRTUxzFzihsnFyhrCw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-YOhlytIMgMHwj2BM/6vOeheyQd4nUuDWpkwLdCqru8c=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v${lib.versions.major finalAttrs.version}/internal/logging.SemVer=v${finalAttrs.version}"
  ];

  env.CGO_ENABLED = false;

  subPackages = [ "." ];

  nativeCheckInputs = [
    versionCheckHook
    go-task
    gotestsum
  ];

  prePatch = ''
    # remove test.ci's dependency on lint since we don't need it and
    # it tries to use remote golangci-lint
    substituteInPlace Taskfile.yml \
      --replace-fail "deps: [lint]" "" \
      --replace-fail "go run gotest.tools/gotestsum" "gotestsum"

    # patch scripts used in e2e testing
    patchShebangs e2e
  '';

  checkPhase = ''
    runHook preCheck

    ${
      # TestRemoteTemplates/schema_validation_OK fails only on x86_64-darwin
      (lib.optionalString (
        stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86
      ) "rm -rf e2e/test_remote_templates/")
    }
    # run unit tests and e2e tests plus pre-gen necessary mocks
    task test.ci

    runHook postCheck
  '';

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/mockery";
  versionCheckProgramArg = "version";

  meta = {
    homepage = "https://github.com/vektra/mockery";
    description = "Mock code autogenerator for Golang";
    maintainers = with lib.maintainers; [
      fbrs
      jk
    ];
    mainProgram = "mockery";
    license = lib.licenses.bsd3;
  };
})
