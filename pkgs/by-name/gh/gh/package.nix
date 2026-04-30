{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
  testers,
  makeWrapper,
  enableTelemetry ? false,
}:

buildGoModule (finalAttrs: {
  pname = "gh";
  version = "2.91.0";

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2ggQd2sCybdtNGwiP7+GqB1CwZDNA/bDq24NC5btNFU=";
  };

  vendorHash = "sha256-4xZAcwn9/vUTkahIlqwyGb/2SYYGusdXY4nye8ldp/g=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # N.B.: using the Makefile is intentional.
  # We pass "nixpkgs" for build.Date to avoid `gh --version` reporting a very old date.
  buildPhase = ''
    runHook preBuild
    make GO_LDFLAGS="-s -w -X github.com/cli/cli/v${lib.versions.major finalAttrs.version}/internal/build.Date=nixpkgs" GH_VERSION=${finalAttrs.version} bin/gh ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) "manpages"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/gh -t $out/bin
  ''
  + lib.optionalString (!enableTelemetry) ''
    wrapProgram $out/bin/gh \
      --set GH_TELEMETRY false
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage share/man/*/*.[1-9]

    installShellCompletion --cmd gh \
      --bash <($out/bin/gh completion -s bash) \
      --fish <($out/bin/gh completion -s fish) \
      --zsh <($out/bin/gh completion -s zsh)
  ''
  + ''
    runHook postInstall
  '';

  # most tests require network access
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "GitHub CLI tool";
    homepage = "https://cli.github.com/";
    changelog = "https://github.com/cli/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "gh";
    maintainers = with lib.maintainers; [
      mdaniels5757
      zowoq
      savtrip
    ];
  };
})
