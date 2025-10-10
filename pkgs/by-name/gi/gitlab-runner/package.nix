{
  lib,
  stdenv,
  bash,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-runner";
  version = "18.4.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kLUQTxj4t6H/by6lzsLmG8S3Ft1QFdUjTa4Y9aCT88o=";
  };

  vendorHash = "sha256-zXyyfJ3VBBcB3Qfsex2pDcDJIRg/HRgFAytWloHHUnM=";

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
    rm shells/abstract_test.go

    # No writable developer environment
    rm common/build_settings_test.go
    rm common/build_test.go
    rm executors/custom/custom_test.go

    # No Docker during build
    rm executors/docker/docker_test.go
    rm executors/docker/services_test.go
    rm executors/docker/terminal_test.go
    rm helpers/docker/auth/auth_test.go

    # No Kubernetes during build
    rm executors/kubernetes/feature_test.go
    rm executors/kubernetes/kubernetes_test.go
    rm executors/kubernetes/overwrites_test.go
  ''
  + lib.optionalString stdenv.buildPlatform.isDarwin ''
    # Invalid bind arguments break Unix socket tests
    substituteInPlace commands/wrapper_test.go \
      --replace-fail "func TestRunnerWrapperCommand_createListener" "func OFF_TestRunnerWrapperCommand_createListener"

    # No keychain access during build breaks X.509 certificate tests
    substituteInPlace helpers/certificate/x509_test.go \
      --replace-fail "func TestCertificate" "func OFF_TestCertificate"
    substituteInPlace network/client_test.go \
      --replace-fail "func TestClientInvalidSSL" "func OFF_TestClientInvalidSSL"
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
