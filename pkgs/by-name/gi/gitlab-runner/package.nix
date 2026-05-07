{
  lib,
  stdenv,
  bash,
  buildGoModule,
  fetchFromGitLab,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-runner";
  version = "18.11.2";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TWpIu6LxFX5ssijlYQA/dmAiPrB0nrHtlS2MWEk6C30=";
  };

  vendorHash = "sha256-xEvvYAVIwHwQDd38P2i6GcgFqf8FPnflWh5IEqmWQdE=";

  # For patchShebangs
  buildInputs = [ bash ];

  patches = [
    ./fix-shell-path.patch
    ./remove-bash-test.patch
  ];

  prePatch = ''
    # Remove some tests that can't work during a nix build

    # Needs the build directory to be a git repo
    substituteInPlace commands/helpers/file_archiver_test.go \
      --replace-fail "func TestCacheArchiverAddingUntrackedFiles" "func OFF_TestCacheArchiverAddingUntrackedFiles" \
      --replace-fail "func TestCacheArchiverAddingUntrackedUnicodeFiles" "func OFF_TestCacheArchiverAddingUntrackedUnicodeFiles"

    # Needs `make development_setup` (git repo at tmp/gitlab-test/)
    rm common/build_settings_test.go
    rm common/build_test.go
    rm executors/custom/custom_test.go

    # Timing-dependent test causes spurious failures on Hydra.
    # Might be fixed upstream in this MR: https://gitlab.com/gitlab-org/gitlab-runner/-/merge_requests/6623
    # Try dropping it on next major version bump
    rm executors/kubernetes/internal/watchers/pod_test.go
  ''
  + lib.optionalString (!stdenv.buildPlatform.isx86_64) ''
    # Kubernetes tests actually work fine inside the network sandbox (they don't
    # expect real Kubernetes), but they fail on aarch64-linux because their
    # mocks expect x86_64
    rm executors/kubernetes/kubernetes_test.go
    rm executors/kubernetes/overwrites_test.go
  ''
  + lib.optionalString stdenv.buildPlatform.isDarwin ''
    # Darwin's sandbox blocks sendfile(2) during local HTTP PUT uploads
    substituteInPlace commands/helpers/cache_archiver_test.go \
      --replace-fail "func TestUploadExistingArchiveIfNeeded" "func OFF_TestUploadExistingArchiveIfNeeded"

    # Invalid bind arguments break Unix socket tests.
    substituteInPlace commands/wrapper_test.go \
      --replace-fail "func TestRunnerWrapperCommand_createListener" "func OFF_TestRunnerWrapperCommand_createListener"

    # No keychain access during build breaks X.509 certificate tests
    substituteInPlace helpers/certificate/x509_test.go \
      --replace-fail "func TestCertificate" "func OFF_TestCertificate"
    substituteInPlace network/client_test.go \
      --replace-fail "func TestClientInvalidSSL" "func OFF_TestClientInvalidSSL"
  '';

  postPatch = ''
    patchShebangs --build helpers/docker/auth/testdata/docker-credential-bin.sh
  '';

  excludedPackages = [
    # Nested dependency Go module, used with go.mod replace directive
    #
    # https://gitlab.com/gitlab-org/gitlab-runner/-/commit/57ea9df5d8a8deb78c8d1972930bbeaa80d05e78
    "./helpers/runner_wrapper/api"
    # Helper scripts for upstream Make targets, not intended for downstream consumers
    "./scripts"
  ];

  ldflags =
    let
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/gitlab-runner/common";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=gitlab-runner"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=${finalAttrs.version}"
      "-X ${ldflagsPackageVariablePrefix}.REVISION=v${finalAttrs.version}"
    ];

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # Make the tests pass outside of GitLab CI
    export CI=0
  '';

  # Many tests start servers which bind to ports
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    install packaging/root/usr/share/gitlab-runner/clear-docker-cache $out/bin
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "GitLab Runner the continuous integration executor of GitLab";
    homepage = "https://docs.gitlab.com/runner";
    license = lib.licenses.mit;
    mainProgram = "gitlab-runner";
    maintainers = with lib.maintainers; [ zimbatm ];
    teams = [ lib.teams.gitlab ];
  };
})
