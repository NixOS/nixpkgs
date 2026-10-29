{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "ecspresso";
  version = "2.8.7";

  src = fetchFromGitHub {
    owner = "kayac";
    repo = "ecspresso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-to/lz3RYipMGi9MaxJkqH5FnXk3JI6HhN/pUj21ZxeY=";
  };

  subPackages = [
    "cmd/ecspresso"
  ];

  vendorHash = "sha256-1DSD5UUuVwaqH1OwJk8rocAO6e9g3hq0DT6k3oPzGAM=";

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
