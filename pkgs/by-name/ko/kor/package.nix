{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kor";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lHNRd3FmcVJduq0XA1r+FqRj0OVmNr22B4Hq/GrnHFs=";
  };

  vendorHash = "sha256-bdnO4Rt0w0rV6/t5u0e0iwkYfbrtRfh6mIzyshT9wlQ=";

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
