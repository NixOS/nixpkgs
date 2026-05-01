{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TW7ccNYdCAySH9QwlKskjsutiUPHfTlmTSTCpOqPdfY=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-vdj0QIqnci6P+4zWrhcxrFwvyu+hF9r6RrqtBGbVToA=";

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
