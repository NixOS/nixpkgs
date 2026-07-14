{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IXvCWuE1KJFCckZjGP9LvEY0S9WzrKPqPx759YIYe4A=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-bvmGvJwjh1tZcKiwIBAveN0Js61/+sh+X6lrJfUYPZ0=";

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
