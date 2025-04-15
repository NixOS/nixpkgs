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
  version = "17.10.1";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pLmDWZHxd9dNhmbcHJRBxPuY0IpcJoXz/fOJeP1lVlA=";
  };

  vendorHash = "sha256-1NteDxcGjsC0kT/9u7BT065EN/rBhaNznegdPHZUKxo=";

  # For patchShebangs
  nativeBuildInputs = [ bash ];

  patches = [
    ./fix-shell-path.patch
    ./remove-bash-test.patch
  ];

  prePatch =
    ''
      # Remove some tests that can't work during a nix build

      # Needs the build directory to be a git repo
      sed -i "s/func TestCacheArchiverAddingUntrackedFiles/func OFF_TestCacheArchiverAddingUntrackedFiles/" commands/helpers/file_archiver_test.go
      sed -i "s/func TestCacheArchiverAddingUntrackedUnicodeFiles/func OFF_TestCacheArchiverAddingUntrackedUnicodeFiles/" commands/helpers/file_archiver_test.go
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
      sed -i "s/func TestRunnerWrapperCommand_createListener/func OFF_TestRunnerWrapperCommand_createListener/" commands/wrapper_test.go

      # No keychain access during build breaks X.509 certificate tests
      sed -i "s/func TestCertificate/func OFF_TestCertificate/" helpers/certificate/x509_test.go
      sed -i "s/func TestClientInvalidSSL/func OFF_TestClientInvalidSSL/" network/client_test.go
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
      "-X ${ldflagsPackageVariablePrefix}.REVISION=${finalAttrs.src.tag}"
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
    maintainers = with lib.maintainers; [ zimbatm ] ++ lib.teams.gitlab.members;
  };
})
