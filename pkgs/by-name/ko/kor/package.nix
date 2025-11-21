{
  lib,
  buildGoModule,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "kor";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "yonahd";
    repo = "kor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eCWVMb5s9nArkW+mKzca/377qSH0k3NUcXyMOqtDUnM=";
  };

  vendorHash = "sha256-ZTiFRBjLT1YHvw2yZAx3vFOvRPF237wbJABGIGr9LKc=";

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
