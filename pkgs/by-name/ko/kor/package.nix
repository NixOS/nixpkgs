{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kor";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B3YKmexo41Ms7MrjoTBdeVaIeN4YuCO7WBrkhoGzP2c=";
  };

  vendorHash = "sha256-vC5GgJI80HsDIYP0oZZk/Tlvy36QZZZDNxz68EDyb8Y=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/yonahd/kor/pkg/utils.Version=${finalAttrs.version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  meta = {
    description = "Golang Tool to discover unused Kubernetes Resources";
    homepage = "https://github.com/yonahd/kor";
    changelog = "https://github.com/yonahd/kor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ivankovnatsky ];
    mainProgram = "kor";
  };
})
