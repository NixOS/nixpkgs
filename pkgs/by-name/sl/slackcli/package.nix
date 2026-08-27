{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "slack-cli";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "slack-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FvztCf0PKc3ZqQroslg6hYTszHBIeV4W8SueEi2Ccc8=";
  };

  vendorHash = "sha256-hQHhyRx05dcysOV4KsljlNQ+TEwLsw/obCjHiECDZb0=";

  subPackages = [ "." ];

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/slackapi/slack-cli/internal/version.Version=v${finalAttrs.version}"
  ];

  doCheck = false;

  postInstall = ''
    mv "$out/bin/slack-cli" "$out/bin/slack"
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    SLACK_DISABLE_TELEMETRY=true "$out/bin/slack" version --skip-update

    runHook postInstallCheck
  '';

  meta = {
    description = "Slack command-line interface";
    homepage = "https://github.com/slackapi/slack-cli";
    changelog = "https://github.com/slackapi/slack-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mulatta ];
    mainProgram = "slack";
  };
})
