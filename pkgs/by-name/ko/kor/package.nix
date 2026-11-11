{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kor";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z+ZZ97sHoHhpfKMzNn5oAJtuvRaDAN2cFT8IoZvggr4=";
  };

  vendorHash = "sha256-ff2MF/2kPczKLpvbfi9WsCMi1zSzZbtrMysaF1t2b38=";

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
