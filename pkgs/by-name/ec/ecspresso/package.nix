{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ljiYcOw5tvDYyPfgICidMiJElHls/dvgyIJW0wukIws=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-7WUnP5OpLHjjDUt9LMASQrefhGMk5RPpsmWne1eZpjQ=";

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
