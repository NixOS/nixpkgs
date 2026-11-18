{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uccB+TDG5Mn5u/NAAtHIDxsPaGdAzN282HyqO4XXY0Q=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-5ihAIIO/8wboyek2+oyhUHcaUUFZvPgPveG3+R78YRI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildDate=none"
    "-X github.com/kayac/ecspresso/v2.Version=${finalAttrs.version}"
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
