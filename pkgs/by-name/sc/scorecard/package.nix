{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  scorecard,
  gitMinimal,
}:

buildGoModule rec {
  pname = "scorecard";
  version = "5.2.1";

  src = fetchFromGitHub {
    owner = "ossf";
    repo = "scorecard";
    tag = "v${version}";
    hash = "sha256-7py6qkal1tNQ2NAi/SiYIEe03NV7INAQRPZ9z5LsusI=";
    # populate values otherwise taken care of by goreleaser,
    # unfortunately these require us to use git. By doing
    # this in postFetch we can delete .git afterwards and
    # maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # 0000-00-00T00:00:00Z
      date -u -d "@$(git log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };
  vendorHash =
    if stdenv.hostPlatform.isLinux then
      "sha256-h78551OfEJTB3Fghc1nIHcfiHp7ygtZgHXpwp1OaFgY="
    else
      "sha256-MTB5ejc4/ivbkp9ytCF+wGvvt+njTkMb1ijVsh5uLps=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X sigs.k8s.io/release-utils/version.gitVersion=v${version}"
    "-X sigs.k8s.io/release-utils/version.gitTreeState=clean"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X sigs.k8s.io/release-utils/version.gitCommit=$(cat COMMIT)"
    ldflags+=" -X sigs.k8s.io/release-utils/version.buildDate=$(cat SOURCE_DATE_EPOCH)"
  '';

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ gitMinimal ];

  preCheck = ''
    # Feed in all but the e2e tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./... | grep -v e2e
    }
    # Ensure other e2e tests that have escaped the e2e dir dont run
    export SKIP_GINKGO=1
  '';

  checkFlags = [
    "-skip TestCollectDockerfilePinning/Non-pinned_dockerfile|TestMixedPinning"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd scorecard \
      --bash <($out/bin/scorecard completion bash) \
      --fish <($out/bin/scorecard completion fish) \
      --zsh <($out/bin/scorecard completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/scorecard --help
    $out/bin/scorecard version 2>&1 | grep "v${version}"
    runHook postInstallCheck
  '';

  passthru.tests.version = testers.testVersion {
    package = scorecard;
    command = "scorecard version";
    version = "v${version}";
  };

  meta = {
    homepage = "https://github.com/ossf/scorecard";
    changelog = "https://github.com/ossf/scorecard/releases/tag/v${version}";
    description = "Security health metrics for Open Source";
    mainProgram = "scorecard";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
      developer-guy
    ];
  };
}
