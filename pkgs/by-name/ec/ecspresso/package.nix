{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "ecspresso";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${version}";
    hash = "sha256-t7XToo/OFrczwF24k51Ae1gFI3/C2HIP5mAJVN8BzLk=";
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
