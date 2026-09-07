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
  version = "3.7.4";

  src = fetchFromGitHub {
    owner = "vektra";
    repo = "mockery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2KhyuS6k8EyPnEVunAIamGJgePmvDVJqSyN0UlAFyvQ=";
  };

  proxyVendor = true;
  vendorHash = "sha256-ockGzV+nj/O6iRcscmhfx220TqJ8LACER/pOPqs21tY=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/vektra/mockery/v${lib.versions.major finalAttrs.version}/internal/logging.SemVer=v${finalAttrs.version}"
  ];

  env = {
    CGO_ENABLED = 0;

    # go.work pulls ./tools into the workspace, which raises mockery's own
    # dependencies to the tools build list. Build and test against go.mod
    # alone, matching what upstream's Taskfile does.
    GOWORK = "off";
  };

  subPackages = [ "." ];

  nativeCheckInputs = [
    versionCheckHook
    go-task
    gotestsum
  ];

  # the e2e remote template tests serve fixtures from an httptest server on
  # loopback, which the darwin sandbox blocks by default
  __darwinAllowLocalNetworking = true;

  prePatch = ''
    # remove test.ci's dependency on lint since we don't need it and
    # it tries to use remote golangci-lint
    #
    # remove test.ci's git-state check, which runs `git diff --exit-code`;
    # the source has no .git directory, so the check cannot work here
    #
    # use gotestsum from nativeCheckInputs rather than building it from the
    # tools module, which would need network access
    substituteInPlace Taskfile.yml \
      --replace-fail "deps: [lint]" "" \
      --replace-fail "      - task: git-state" "" \
      --replace-fail "    deps: [tools.gotestsum]" "" \
      --replace-fail "./tools/gotestsum{{exeExt}}" "gotestsum"

    # the e2e scripts reach go-task through the workspace, which GOWORK=off
    # rules out; use go-task from nativeCheckInputs instead
    substituteInPlace \
      e2e/test_mockery_generation.sh \
      e2e/test_infinite_mocking.sh \
      e2e/test_missing_interface/run.sh \
      --replace-fail "go run github.com/go-task/task/v3/cmd/task" "task"

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
