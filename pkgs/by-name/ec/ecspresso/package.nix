{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKFaz31Dy4w8QLsNMyjVbbK/984D37snlFbNYeYr8SE=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-NFuWMfw31BfolRd8yxleVdwFi/XcnHcSTOlqkm/stko=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildDate=none"
    "-X main.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "version";

  meta = {
    description = "Deployment tool for ECS";
    mainProgram = "ecspresso";
    license = lib.licenses.mit;
    homepage = "https://github.com/kayac/ecspresso/";
    maintainers = with lib.maintainers; [
      FKouhai
    ];
  };
})
