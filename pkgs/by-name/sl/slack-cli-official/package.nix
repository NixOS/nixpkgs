{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "slack-cli-official";
  version = "4.2.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "slackapi";
    repo = "slack-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5mI0pJ/QSU+gh1Lx7ss5xRWMOafYOfku3CAe2gD+UIM=";
  };

  vendorHash = "sha256-Xdb2TrvStvxzbY18obNV3GESoVtwp3Q1+7mhJ1WMvXY=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X github.com/slackapi/slack-cli/internal/version.Version=v${finalAttrs.version}"
  ];

  # As per the usage documentation of this package, it expects the program to be named `slack`
  postInstall = ''
    mv "$out/bin/slack-cli" "$out/bin/slack"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Official Slack developer CLI";
    homepage = "https://docs.slack.dev/tools/slack-cli/";
    downloadPage = "https://github.com/slackapi/slack-cli";
    changelog = "https://github.com/slackapi/slack-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "slack";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ alexnortung ];
  };
})
