{
  lib,
  fetchFromGitHub,
  buildGo127Module,
  installShellFiles,
  stdenv,
  versionCheckHook,
  makeWrapper,
}:

buildGo127Module (finalAttrs: {
  pname = "gh";
  version = "2.101.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cli";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EoKF2m5sZP+uQ5AVOKkFqSCACfkeUc7vnH8PHWCO6FE=";
  };

  vendorHash = "sha256-4KYQBgMNc/sI0mbcXSfJ7A/77VAS6NM8TOzQ3w7AlK8=";

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
    installBin bin/gh
    wrapProgram $out/bin/gh \
      --set-default GH_TELEMETRY false
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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
