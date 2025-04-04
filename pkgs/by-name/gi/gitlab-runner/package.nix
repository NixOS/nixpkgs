{
  lib,
  bash,
  buildGoModule,
  fetchFromGitLab,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "gitlab-runner";
  version = "17.2.0";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    hash = "sha256-a2Igy4DS3fYTvPW1vvDrH/DjMQ4lG9cm/P3mFr+y9s4=";
  };

  vendorHash = "sha256-1MwHss76apA9KoFhEU6lYiUACrPMGYzjhds6nTyNuJI=";

  # For patchShebangs.
  buildInputs = [ bash ];

  patches = [
    ./fix-shell-path.patch
    ./remove-bash-test.patch
  ];

  prePatch = ''
    # Remove some tests that can't work during a nix build.

    # Requires to run in a git repo
    sed -i "s/func TestCacheArchiverAddingUntrackedFiles/func OFF_TestCacheArchiverAddingUntrackedFiles/" commands/helpers/file_archiver_test.go
    sed -i "s/func TestCacheArchiverAddingUntrackedUnicodeFiles/func OFF_TestCacheArchiverAddingUntrackedUnicodeFiles/" commands/helpers/file_archiver_test.go

    # No writable developer environment.
    rm common/build_test.go
    rm common/build_settings_test.go
    rm executors/custom/custom_test.go

    # No docker during build.
    rm executors/docker/terminal_test.go
    rm executors/docker/docker_test.go
    rm helpers/docker/auth/auth_test.go
    rm executors/docker/services_test.go
  '';

  excludedPackages = [
    # CI helper script for pushing images to Docker and ECR registries.
    #
    # https://gitlab.com/gitlab-org/gitlab-runner/-/merge_requests/4139
    "./scripts/sync-docker-images"
  ];

  ldflags =
    let
      ldflagsPackageVariablePrefix = "gitlab.com/gitlab-org/gitlab-runner/common";
    in
    [
      "-X ${ldflagsPackageVariablePrefix}.NAME=gitlab-runner"
      "-X ${ldflagsPackageVariablePrefix}.VERSION=v${version}"
      "-X ${ldflagsPackageVariablePrefix}.REVISION=${src.rev}"
    ];

  preCheck = ''
    # Make the tests pass outside of GitLab CI.
    export CI=0
  '';

  postInstall = ''
    install packaging/root/usr/share/gitlab-runner/clear-docker-cache $out/bin
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    homepage = "https://docs.gitlab.com/runner";
    license = licenses.mit;
    mainProgram = "gitlab-runner";
    maintainers = with maintainers; [ zimbatm ] ++ teams.gitlab.members;
  };
}
