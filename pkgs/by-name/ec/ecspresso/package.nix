{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "ecspresso";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${version}";
    hash = "sha256-9C/OJ1rnH77jcF3hDr2uyXcNViAkM84LjmkJsKmQkXo=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-tL/AjGU/Pi5ypcv9jqUukg6sGJqpPlHhwxzve7/KgDo=";

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
