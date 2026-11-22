{
  lib,
  buildGo127Module,
  fetchFromGitLab,
  installShellFiles,
  makeBinaryWrapper,
  stdenv,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  gitMinimal,
}:

buildGo127Module (finalAttrs: {
  pname = "glab";
  version = "1.130.0";

  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9miIOYrUvUfvB6//j/gV19Sn85CCBkSAcY/cZ5sXO0I=";
  };

  vendorHash = "sha256-4Ate/Cm5gLoEjm9nEm6I7GHfQZjygalbhPiOrxYpDf8=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  subPackages = [ "cmd/glab" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    make manpage
    installManPage share/man/man1/*
    installShellCompletion --cmd glab \
      --bash <($out/bin/glab completion -s bash) \
      --fish <($out/bin/glab completion -s fish) \
      --zsh <($out/bin/glab completion -s zsh)

    wrapProgram $out/bin/glab \
      --set-default GLAB_CHECK_UPDATE 0 \
      --set-default GLAB_SEND_TELEMETRY 0
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  preCheck = ''
    git init
  '';

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "Test_addTelemetryHook"
        "Test_buildTelemetryEvent"
        "Test_sendTelemetryData"
      ];
    in
    [ "-skip=^(${lib.concatStringsSep "|" skippedTests})" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    gitMinimal
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "GitLab CLI tool bringing GitLab to your command line";
    license = lib.licenses.mit;
    homepage = "https://gitlab.com/gitlab-org/cli";
    changelog = "https://gitlab.com/gitlab-org/cli/-/releases/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      anthonyroussel
      turebentzin
    ];
    mainProgram = "glab";
  };
})
