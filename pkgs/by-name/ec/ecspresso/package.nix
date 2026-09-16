{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dwoJhQ1o2rpuMo7txIXsIAeAOxUHvni0aG56lP1FpnQ=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-r2iLST2m1zE7keLHSYzdonM1ofCZnT/BhNWCG8/Zf/k=";

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
