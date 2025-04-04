{
  lib,
  buildGoModule,
  fetchFromGitLab,
  bash,
}:

let
  version = "17.9.2";
in
buildGoModule rec {
  inherit version;
  pname = "gitlab-runner";

  # For patchShebangs
  buildInputs = [ bash ];

  vendorHash = "sha256-t/FVaDga2ogyqgVdJuBMSyls3rricfqIy5bFSH4snk4=";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-runner";
    rev = "v${version}";
    hash = "sha256-kcDsjmx/900p2ux7dyGHSOVqXxxVhg2/o0a3NYcqIrA=";
  };

  patches = [
    ./remove-bash-test.patch
    # Asserts for x86_64 architecture
    # https://gitlab.com/gitlab-org/gitlab-runner/-/issues/38697
    ./disable-kubernetes-test-on-aarch64.patch
    # Fails in nix sandbox
    ./disable-unix-socket-tests-on-darwin.patch
    # Fails in nix sandbox
    # Returns OSStatus -26276
    ./disable-x509-certificate-check-on-darwin.patch
  ];

  prePatch = ''
    # Remove some tests that can't work during a nix build

    # Requires to run in a git repo
    sed -i "s/func TestCacheArchiverAddingUntrackedFiles/func OFF_TestCacheArchiverAddingUntrackedFiles/" commands/helpers/file_archiver_test.go
    sed -i "s/func TestCacheArchiverAddingUntrackedUnicodeFiles/func OFF_TestCacheArchiverAddingUntrackedUnicodeFiles/" commands/helpers/file_archiver_test.go

    # No writable developer environment
    rm common/build_test.go
    rm common/build_settings_test.go
    rm executors/custom/custom_test.go

    # No docker during build
    rm executors/docker/terminal_test.go
    rm executors/docker/docker_test.go
    rm helpers/docker/auth/auth_test.go
    rm executors/docker/services_test.go
  '';

  postPatch = ''
    substituteInPlace Makefile --replace-fail "export VERSION := \$(shell ./ci/version)" "export VERSION := ${version}"
    substituteInPlace Makefile --replace-fail "REVISION := \$(shell git rev-parse --short=8 HEAD || echo unknown)" "REVISION := v${version}"
  '';

  excludedPackages = [
    # CI helper script for pushing images to Docker and ECR registries
    # https://gitlab.com/gitlab-org/gitlab-runner/-/merge_requests/4139
    "./scripts/sync-docker-images"
  ];

  buildPhase = ''
    runHook preBuild
    make -j $NIX_BUILD_CORES runner-and-helper-bin-host
    runHook postBuild
  '';

  postInstall = ''
    mkdir $out/bin
    cp out/binaries/gitlab-runner-$GOOS-$GOARCH  $out/bin/gitlab-runner
    install packaging/root/usr/share/gitlab-runner/clear-docker-cache $out/bin
  '';

  preCheck = ''
    # Make the tests pass outside of GitLab CI
    export CI=0
  '';

  checkPhase = ''
    runHook preCheck
    make simple-test
    runHook postCheck
  '';

  meta = with lib; {
    description = "GitLab Runner the continuous integration executor of GitLab";
    license = licenses.mit;
    homepage = "https://docs.gitlab.com/runner/";
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ zimbatm ] ++ teams.gitlab.members;
  };
}
