{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "ecspresso";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${version}";
    hash = "sha256-tpTtGU0tqBuRu61jtEdK+/JbJsWdVEks1iKCsne9sQQ=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-P5qx6rNFzyKA4L/bAIsdzL1McGkeRF/5ah0gRx1lBZk=";

  ldflags = [
    "-s"
    "-w"
    "-X main.buildDate=none"
    "-X main.Version=${version}"
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
}
